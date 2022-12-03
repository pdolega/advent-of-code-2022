
class CaloriesCounting {
    func countCalories(calories: [Int?]) -> Int {

        var highestValue = 0
        var acc = 0
        for calorie in calories {
            switch calorie {
                case .none:
                    if acc > highestValue {
                        highestValue = acc
                    }
                    acc = 0

                case let calorie?:
                    acc += calorie
            }
        }

        return highestValue
    }

    func countTop3Total(calories: [Int?]) -> Int {
        var highestTop3 = [0, 0, 0]
        var acc = 0
        for calorie in calories {
            switch calorie {
                case .none:
                    highestTop3.append(acc)
                    highestTop3 = Array(highestTop3.sorted().dropFirst())
                    acc = 0

                case let calorie?:
                    acc += calorie
            }
        }

        return highestTop3.reduce(0) { $0 + $1 }
    }
}


