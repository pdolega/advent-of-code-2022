import Foundation

class HotAirBalloons {
    func sumAllNumbers(input: [String]) -> String {
        let result = input.map { Array($0) }.reduce(Array("0")) { sum, nextNum in
            add(sum, nextNum)
        }

        return String(result)
    }

    private func add(_ lhs: [Character], _ rhs: [Character]) -> [Character] {
        let lowerBound = -2
        let upperBound = 2

        let maxLength = max(lhs.count, rhs.count)

        let num1 = Array(lhs.reversed() + Array.init(repeating: "0", count: maxLength - lhs.count))
        let num2 = Array(rhs.reversed() + Array.init(repeating: "0", count: maxLength - rhs.count))

        var result = ""
        var carry = 0

        for position in 0..<maxLength {
            let numVal1 = toDecNum(num1[position])
            let numVal2 = toDecNum(num2[position])

            let positionResult = numVal1 + numVal2 + carry
            carry = 0

            if positionResult > upperBound {
                carry = 1
                let digitResult = lowerBound - 1 + (positionResult - upperBound)
                result.append(toStrangeNum(digitResult))
            } else if positionResult < lowerBound {
                carry = -1
                let digitResult = upperBound + 1 + (positionResult - lowerBound)
                result.append(toStrangeNum(digitResult))
            } else {
                result.append(toStrangeNum(positionResult))
            }
        }

        if carry != 0 {
            result.append(toStrangeNum(carry))
        }

        return result.reversed()
    }

    private func toDecNum(_ char: Character) -> Int {
        switch char {
            case "=": return -2
            case "-": return -1
            default: return Int(String(char))!
        }
    }

    private func toStrangeNum(_ val: Int) -> Character {
        switch val {
            case -2: return Character("=")
            case -1: return Character("-")
            default: return Character(String(val))
        }
    }
}