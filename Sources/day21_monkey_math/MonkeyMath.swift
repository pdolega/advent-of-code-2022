import Foundation

protocol MonkeyTree: Hashable, Equatable, CustomStringConvertible {
    var name: String {get}

    func evaluate() -> Int
}

extension MonkeyTree  {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: any MonkeyTree, rhs: any MonkeyTree) -> Bool {
        lhs.name == rhs.name
    }
}

class MonkeyExpr: MonkeyTree  {
    let name: String
    var operation: Operation? = nil

    var result: Int? =  nil

    var leftMonkey: (any MonkeyTree)? = nil
    var rightMonkey: (any MonkeyTree)? = nil

    init(name: String) {
        self.name = name
    }

    func evaluate() -> Int {
        if let result {
            return result
        } else {
            return operation!.calculate(left: leftMonkey!.evaluate(), right: rightMonkey!.evaluate())
        }
    }

    static func == (lhs: MonkeyExpr, rhs: MonkeyExpr) -> Bool {
        lhs.name == rhs.name
    }
}

extension MonkeyExpr: CustomStringConvertible {
    var description: String {
        "(\(leftMonkey!) \(operation!.rawValue) \(rightMonkey!))"
    }
}

class MonkeyVal: MonkeyTree  {
    let name: String
    let result: Int

    init(name: String, value: Int) {
        self.name = name
        self.result = value
    }

    func map(mapping: (Int) -> Int) -> MonkeyVal {
        return MonkeyVal(name: self.name, value: mapping(self.result))
    }

    func evaluate() -> Int {
        result
    }

    static func == (lhs: MonkeyVal, rhs: MonkeyVal) -> Bool {
        lhs.name == rhs.name
    }
}

extension MonkeyVal: CustomStringConvertible {
    var description: String {
        result.description
    }
}

class MonkeyUnknown: MonkeyTree  {
    let name: String
    let dividend: Int = 1
    let divider: Int = 1

    init(name: String) {
        self.name = name
    }

    func evaluate() -> Int {
        assertionFailure("Cannot evaluate unknown")
        return -1
    }

    static func == (lhs: MonkeyUnknown, rhs: MonkeyUnknown) -> Bool {
        lhs.name == rhs.name
    }
}

extension MonkeyUnknown: CustomStringConvertible {
    var description: String {
        return "x"
    }
}

enum Operation: String {
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case Equal = "="

    static func parse(operatorStr: String) -> Operation {
        switch operatorStr {
            case "+": return .Add
            case "-": return .Subtract
            case "*": return .Multiply
            case "/": return .Divide
            case "=": return .Equal
            default:
                assertionFailure("Unknown operator encountered: \(operatorStr)")
                return .Add
        }
    }

    func calculate(left: Int, right: Int) -> Int {
        switch self {
            case .Add: return left + right
            case .Subtract: return left - right
            case .Multiply: return left * right
            case .Divide: return left / right
            case .Equal: return left == right ? 1 : 0
        }
    }
}

class MonkeyMath {

    func calculateAllKnown(input: [String]) -> Int {
        let monkeys = parseInput(input: input)
        let monkeyMap = buildDeps(monkeys: monkeys)
        let result = calc(monkeyMap: monkeyMap)


        return result
    }

    func calculateHumnUknown(input: [String]) -> Int {
        var monkeys = parseInput(input: input)
        let monkeyMap = buildDeps(monkeys: monkeys)
        let result = unknownCalculation(monkeys: monkeyMap)

        return result
    }

    private func unknownCalculation(monkeys: [String: any MonkeyTree]) -> Int {

        var monkeyMap = monkeys

        let root = monkeyMap["root"]!
        if let root = root as? MonkeyExpr {
            root.operation = .Equal
        }

        let humn = MonkeyUnknown(name: "humn")
        monkeyMap[humn.name] = humn

        monkeyMap.forEach { key, value in
            if let expr = value as? MonkeyExpr {

                if expr.leftMonkey?.name == humn.name {
                    expr.leftMonkey = humn
                }

                if expr.rightMonkey?.name == humn.name {
                    expr.rightMonkey = humn
                }
            }
        }

        let simplifiedRoot = simplify(monkey: root) as? MonkeyExpr


        var (rootLeft, rootRight) = (simplifiedRoot!.leftMonkey, simplifiedRoot!.rightMonkey)

        let rootValue = (rootLeft is MonkeyVal ? rootLeft : rootRight) as? MonkeyVal
        var rootExpr = (rootLeft is MonkeyExpr ? rootLeft : rootRight) as? MonkeyExpr
        return calculateUnknownValue(rootExpr: rootExpr!, initialValue: rootValue!).result
    }

    private func calculateUnknownValue(rootExpr: MonkeyExpr, initialValue: MonkeyVal) -> MonkeyVal {
        var expr: (any MonkeyTree)? = rootExpr
        var rootValue = initialValue

        while var currentExpr = expr as? MonkeyExpr  {
            switch (currentExpr.leftMonkey, currentExpr.operation, currentExpr.rightMonkey) {
                case (let left, .Add, let right as MonkeyVal):
                    rootValue = rootValue.map { $0 - right.result }
                    expr = left

                case (let left as MonkeyVal, .Add, let right):
                    rootValue = rootValue.map { $0 - left.result }
                    expr = right

                case (let left, .Subtract, let right as MonkeyVal):
                    rootValue = rootValue.map { $0 + right.result }
                    expr = left

                case (let left as MonkeyVal, .Subtract, let right):
                    rootValue = rootValue.map { -($0 - left.result) }
                    expr = right

                case (let left, .Multiply, let right as MonkeyVal):
                    rootValue = rootValue.map { $0 / right.result }
                    expr = left

                case (let left as MonkeyVal, .Multiply, let right):
                    rootValue = rootValue.map { $0 / left.result }
                    expr = right

                case (let left, .Divide, let right as MonkeyVal):
                    rootValue = rootValue.map { $0 * right.result }
                    expr = left

                case (let left as MonkeyVal, .Divide, let right):
                    rootValue = rootValue.map { $0 * left.result }
                    expr = right

                default:
                    fatalError("Left / Right / Operation combination unexpected")
            }
        }

        return rootValue
    }

    private func calc(monkeyMap: [String: any MonkeyTree]) -> Int {
        let root = monkeyMap["root"]!
        let result = root.evaluate()
        print("Result is: \(result)")

        return result
    }

    private func simplify(monkey: any MonkeyTree) -> any MonkeyTree {
        if let value = monkey as? MonkeyVal {
            return value
        } else if let unknown = monkey as? MonkeyUnknown {
            return unknown
        } else if let expr = monkey as? MonkeyExpr {
            let leftMonkey = simplify(monkey: expr.leftMonkey!)
            expr.leftMonkey = leftMonkey
            let rightMonkey = simplify(monkey: expr.rightMonkey!)
            expr.rightMonkey = rightMonkey

            if let leftVal = leftMonkey as? MonkeyVal, let rightVal = rightMonkey as? MonkeyVal {
                return MonkeyVal(
                    name: expr.name,
                    value: expr.operation!.calculate(left: leftVal.result, right: rightVal.result)
                )
            } else {
                return monkey
            }
        } else {
            fatalError("Unexpected monkey type encountered: \(monkey)")
        }
    }

    private func buildDeps(monkeys: [(any MonkeyTree, String?, String?)]) -> [String: any MonkeyTree] {
        let dictionary = Dictionary(
                uniqueKeysWithValues: monkeys.map { monkeyNum, _, _ in (monkeyNum.name, monkeyNum) }
        )

        for (monkey, left, right) in monkeys {

            if let expr = monkey as? MonkeyExpr {
                    expr.leftMonkey = dictionary[left!]!
                    expr.rightMonkey = dictionary[right!]!
            }
        }
        return dictionary
    }

    private func parseInput(input: [String]) -> [(any MonkeyTree, String?, String?)] {
        var monkeys: [(any MonkeyTree, String?, String?)] = []

        input.forEach { line in
            let capturesWithOperation = Util.firstRegexMatch(string: line, pattern: #"(.+)\: (.+) ([+|\-|*|/]) (.+)"#)
            let capturesWithValue = Util.firstRegexMatch(string: line, pattern: #"(.+)\: (\d+)"#)

            if let captures = capturesWithOperation {
                let name = captures[1]

                let leftMonkey = captures[2]
                let operand = captures[3]
                let rightMonkey = captures[4]

                let monkey = MonkeyExpr(name: name)
                monkey.operation = Operation.parse(operatorStr: operand)
                monkeys.append((monkey, leftMonkey, rightMonkey))
            } else if let captures = capturesWithValue {
                let name = captures[1]
                let value = Int(captures[2])!
                let monkey = MonkeyVal(name: name, value: value)
                monkeys.append((monkey, nil, nil))
            } else {
                assertionFailure("Row not matched: \(line)")
            }
        }
        return monkeys
    }

    private func splitVal(expr: MonkeyExpr) -> (any MonkeyTree, MonkeyVal) {
        if let val = expr.leftMonkey! as? MonkeyVal {
            return (expr.rightMonkey!, val)
        } else if let val = expr.rightMonkey! as? MonkeyVal {
            return (expr.leftMonkey!, val)
        } else {
            fatalError("Neither side contains val")
        }
    }
}
