import Foundation

class BlizzardBasin {

    enum Dir: String {
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"

        func next(currentPosition: Point, blocked: Set<Point>, gridSize: Dimensions) -> Point {
            let maxX = gridSize.width - 2, maxY = gridSize.height - 2

            switch self {
                case .up:
                    let newPosition = currentPosition.moveBy(y: -1)
                    if blocked.contains(newPosition) {
                        return Point(x: currentPosition.x, y: maxY)
                    } else {
                        return newPosition
                    }

                case .down:
                    let newPosition = currentPosition.moveBy(y: 1)
                    if blocked.contains(newPosition) {
                        return Point(x: currentPosition.x, y: 1)
                    } else {
                        return newPosition
                    }

                case .left:
                    let newPosition = currentPosition.moveBy(x: -1)
                    if blocked.contains(newPosition) {
                        return Point(x: maxX, y: currentPosition.y)
                    } else {
                        return newPosition
                    }

                case .right:
                    let newPosition = currentPosition.moveBy(x: 1)
                    if blocked.contains(newPosition) {
                        return Point(x: 1, y: currentPosition.y)
                    } else {
                        return newPosition
                    }
            }
        }
    }

    struct ProblemConfig {
        let blizzards: [Point: Dir]
        let blocked: Set<Point>
        let size: Dimensions
        let startPoint: Point
        let targetPoint: Point
    }

    struct State: Hashable, Equatable {
        let point: Point
        let leg: Int
    }

    func findPath(input: [String], tripLegs: Int = 1) -> Int {
        let config = parseInput(input: input)
        var blizzards = Dictionary(uniqueKeysWithValues: config.blizzards.map { key, value in (key, [value]) })

        var possiblePoints: Set<State> = Set([State(point: config.startPoint, leg: 0)])

        var maxMinute = 0
        var startTime = DispatchTime.now().uptimeNanoseconds

        printGrid(gridSize: config.size, position: config.startPoint, blocked: config.blocked, blizzards: blizzards)

        var minute = 0
        let target = State(point: config.targetPoint, leg: tripLegs)

        while !possiblePoints.contains(target) {

            let diff = DispatchTime.now().uptimeNanoseconds - startTime
            startTime = DispatchTime.now().uptimeNanoseconds
            let maxStage = possiblePoints.max { $0.leg < $1.leg }?.leg ?? 0

            blizzards = newBlizzardPositions(blocked: config.blocked, blizzards: blizzards, gridSize: config.size)
            print("Minute \(minute) reached after \(diff/1_000_000)ms... (queue size: \(possiblePoints.count), max stage: \(maxStage))")

            minute += 1
            let newPossiblePoints = possiblePoints.flatMap { position in
                getPossibleMoves(currentStage: position, start: config.startPoint, target: config.targetPoint, blocked: config.blocked, blizzards: blizzards)
            }

            possiblePoints = Set(newPossiblePoints)
        }

        return minute
    }


    private func printGrid(gridSize: Dimensions, position: Point? = nil, blocked: Set<Point>, blizzards: [Point: [Dir]]) {
        for y in 0..<gridSize.height {
            var line = ""
            for x in 0..<gridSize.width {
                let point = Point(x: x, y: y)

                if blocked.contains(point) {
                    line.append("#")
                    continue
                }

                if position == point {
                    line.append("E")
                    continue
                }

                let foundBlizzards = blizzards[point]
                if let foundBlizzards {
                    if foundBlizzards.count > 1 {
                        line.append(String(foundBlizzards.count))
                    } else {
                        line.append(foundBlizzards.first!.rawValue)
                    }
                } else {
                    line.append(".")
                }
            }

            print(line)
        }

        print()
    }

    private func newBlizzardPositions(blocked: Set<Point>, blizzards: [Point: [Dir]], gridSize: Dimensions) -> [Point: [Dir]] {
        var newBlizzards: [Point: [Dir]] = [:]
        let maxX = gridSize.width - 2
        let maxY = gridSize.height - 2

        blizzards.forEach { position, dirList in
            dirList.forEach { dir in
                let newPosition = dir.next(currentPosition: position, blocked: blocked, gridSize: gridSize)

                var newDirs = newBlizzards[newPosition] ?? []
                newDirs.append(dir)
                newBlizzards[newPosition] = newDirs
            }
        }

        return newBlizzards
    }

    private func getPossibleMoves(currentStage: State, start: Point, target: Point, blocked: Set<Point>, blizzards: [Point: [Dir]]) -> Set<State> {
        let currentPosition = currentStage.point
        let candidatesPoints = Set([currentPosition.moveBy(x: -1), currentPosition.moveBy(x: 1), currentPosition.moveBy(y: -1), currentPosition.moveBy(y: 1), currentPosition])

        let candidates = candidatesPoints.map { point in
            if currentStage.leg % 2 == 0 && point == target {
                return State(point: point, leg: currentStage.leg + 1)
            } else if currentStage.leg % 2 != 0 && point == start {
                return State(point: point, leg: currentStage.leg + 1)
            } else {
                return State(point: point, leg: currentStage.leg)
            }
        }

        let filtered = Set(candidates).filter { stage in
            let point = stage.point

            if point.x < 0 || point.y < 0 {
                return false
            }

            if blocked.contains(point) {
                return false
            }

            if blizzards[point] != nil {
                return false
            }

            // prevent going back to start
            if point != currentPosition && currentStage.leg == stage.leg && point == start {
                return false
            }

            return true
        }

        return filtered
    }

    private func parseInput(input: [String]) -> ProblemConfig {
        var blizzards: [Point: Dir] = [:]
        var blocked: Set<Point> = Set()

        let startX = Array(input.first!).index(of: Character("."))!
        let start = Point(x: startX, y: 0)

        var targetX = Array(input.last!).index(of: Character("."))!
        let target = Point(x: targetX, y: input.count - 1)

        input.enumerated().forEach { y, line in
            line.enumerated().forEach { x, char in
                if char == Character("#") {
                    blocked.insert(Point(x: x, y: y))
                }

                if char == Character("<") {
                    blizzards[Point(x: x, y: y)] = Dir.left
                } else if char == Character(">") {
                    blizzards[Point(x: x, y: y)] = Dir.right
                } else if char == Character("v") {
                    blizzards[Point(x: x, y: y)] = Dir.down
                } else if char == Character("^") {
                    blizzards[Point(x: x, y: y)] = Dir.up
                }
            }
        }

        return ProblemConfig(
                blizzards: blizzards, blocked: blocked,
                size: Dimensions(width: input.first!.count, height: input.count),
                startPoint: start, targetPoint: target
        )
    }
}


