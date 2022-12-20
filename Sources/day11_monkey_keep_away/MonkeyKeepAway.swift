import Foundation

class Monkey {
    var number: Int
    var items: [Int] = []

    var operation: (Int) -> Int = { x in 0 }

    var divisibleByTest: Int = -1
    var testTrueMonkey: Int = -1
    var testFalseMonkey: Int = -1

    var inspections: Int = 0

    init(number: Int) {
        self.number = number
    }
}

extension Monkey: CustomStringConvertible {
    var description: String {
        "Monkey(number: \(number), items: \(items), inspections: \(inspections)"
    }
}

class MonkeyKeepAway {

    func calculateInspections(input: [String], divider: Int = 1, rounds: Int = 10_000) -> Int {
        var monkeys = parseInput(input: input)
        let overflowLimit = monkeys.reduce(1) { (res, next) in res * next.divisibleByTest }

        for _ in 1...rounds {
            for monkey in monkeys {

                let oldItems = monkey.items
                monkey.items = []

                oldItems.forEach { item in
                    monkey.inspections += 1
                    let newWorryLevel = (monkey.operation(item) / divider) % overflowLimit

                    if newWorryLevel % monkey.divisibleByTest == 0 {
                        monkeys[monkey.testTrueMonkey].items.append(newWorryLevel)
                    } else {
                        monkeys[monkey.testFalseMonkey].items.append(newWorryLevel)
                    }
                }
            }

            // debug
//            if ([1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000].contains { $0 == round }) {
//                print("Round \(round) finished")
//                for monkey in monkeys {
//                    print(monkey)
//                }
//            }
        }

        monkeys.sort { $0.inspections > $1.inspections  }
        return monkeys[0].inspections * monkeys[1].inspections
    }

    private func parseInput(input: [String]) -> [Monkey] {
        var monkeys: [Monkey] = []

        input.forEach { line in
            if let monkeyNo = parseMonkey(line: line) {
                monkeys.append(Monkey(number: monkeyNo))
            }

            if let items = parseItems(line: line) {
                monkeys.last!.items = items
            }

            if let operation = parseOperation(monkeyInt: monkeys.last!.number, line: line) {
                monkeys.last!.operation = operation
            }

            if let divisible = parseDivisibleTest(line: line) {
                monkeys.last!.divisibleByTest = divisible
            }

            if let trueTest = parseTrueTest(line: line) {
                monkeys.last!.testTrueMonkey = trueTest
            }

            if let falseTest = parseFalseTest(line: line) {
                monkeys.last!.testFalseMonkey = falseTest
            }
        }

        return monkeys
    }

    private func parseMonkey(line: String) -> Int? {
        matchFirstInt(line: line, pattern: #"Monkey (\d)\:"#)
    }

    private func parseItems(line: String) -> [Int]? {
        if let captures = Util.firstRegexMatch(string: line, pattern: #"Starting items: (.*)"#) {
            let items = captures[1]
            return items.components(separatedBy: ", ").map { Int($0)! }
        } else {
            return nil
        }
    }

    private func parseOperation(monkeyInt: Int, line: String) -> ((Int) -> Int)? {
        if let captures = Util.firstRegexMatch(string: line, pattern: #"Operation: new = old (\+|\*) (.+)"#) {
            let mathOperator = captures[1]
            let operatorLambda = parseMathOperation(mathOperator: mathOperator)

            let secondVal = captures[2]
            let secondValInt: Int? = Int(secondVal)
            if secondValInt == nil && secondVal != "old" {
                assertionFailure("Unhandled second parameter value: \(secondVal)")
            }

            return { operatorLambda($0, secondValInt ?? $0) }
        } else {
            return nil
        }
    }

    private func parseMathOperation(mathOperator: String) -> (Int, Int) -> Int {
        switch mathOperator {
            case "+": return { $0 + $1 }
            case "*": return { $0 * $1 }
            default: assertionFailure("Unhandled math operation: \(mathOperator)")
        }
        return { $0 + $1 }
    }

    private func parseDivisibleTest(line: String) -> Int? {
        matchFirstInt(line: line, pattern: #"Test\: divisible by (\d+)"#)
    }

    private func parseTrueTest(line: String) -> Int? {
        matchFirstInt(line: line, pattern: #"If true\: throw to monkey (\d+)"#)
    }

    private func parseFalseTest(line: String) -> Int? {
        matchFirstInt(line: line, pattern: #"If false\: throw to monkey (\d+)"#)
    }

    private func matchFirstInt(line: String, pattern: String) -> Int? {
        if let captures = Util.firstRegexMatch(string: line, pattern: pattern) {
            return Int(captures[1])
        } else {
            return nil
        }
    }
}