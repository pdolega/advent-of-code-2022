import Foundation

enum Choice: Int {
    case rock = 1
    case paper = 2
    case scissors = 3

    static func parse(string: String) -> Choice? {
        switch string {
            case "A", "X":
                return .rock
            case "B", "Y":
                return .paper
            case "C", "Z":
                return .scissors
            default:
                return nil
        }
    }

    func winsWith() -> Choice {
        switch self {
            case .rock:
                return .scissors
            case .paper:
                return .rock
            case .scissors:
                return .paper
        }
    }

    func loosesWith() -> Choice {
        switch self {
            case .rock:
                return .paper
            case .paper:
                return .scissors
            case .scissors:
                return .rock
        }
    }
}

enum Outcome: Int {
    case lost = 0
    case draw = 3
    case won = 6

    static func parse(string: String) -> Outcome? {
        switch string {
        case "X":
            return .lost
        case "Y":
            return .draw
        case "Z":
            return .won
        default:
            return nil
        }
    }
}

class RockPaperScissorsStrategy {
    func calculate1stResult(strategy: [(Choice, Choice)]) -> Int {
        var result = 0

        strategy.forEach { (choice, response) in
            // value of outcome
            switch choice {
                case response.winsWith():
                    result += Outcome.won.rawValue

                case response.loosesWith():
                    result += Outcome.lost.rawValue

                default:
                    result += Outcome.draw.rawValue
            }

            // value of response
            result += response.rawValue
        }

        return result
    }

    func calculate2ndResult(strategy: [(Choice, Outcome)]) -> Int {
        var result = 0

        strategy.forEach { (choice, outcome) in
            // value of response
            switch outcome {
                case .won:
                    result += choice.loosesWith().rawValue

                case .lost:
                    result += choice.winsWith().rawValue

                case .draw:
                    result += choice.rawValue
            }

            // value of outcome
            result += outcome.rawValue
        }

        return result
    }
}
