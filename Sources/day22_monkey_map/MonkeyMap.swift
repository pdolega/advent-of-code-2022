import Foundation

enum Dir: Int {
    case Right = 0
    case Down = 1
    case Left = 2
    case Up = 3

    func turn(degrees: Int) -> Dir {
        let quarters = degrees / 90
        return Dir(rawValue: (rawValue + quarters) % 4)!
    }

    func move(point: Point) -> Point {
        switch self {
        case .Right: return point.moveBy(x: 1)
        case .Down: return point.moveBy(y: 1)
        case .Left: return point.moveBy(x: -1)
        case .Up: return point.moveBy(y: -1)
        }
    }

    func turn(string: String) -> Dir {
        if string == "R" {
            return Dir(rawValue: (rawValue + 1) % 4)!
        } else {
            var newVal = rawValue - 1
            if newVal < 0 {
                newVal = 3
            }

            return Dir(rawValue: newVal)!
        }
    }

    static func parseDir(string: String) -> Dir {
        switch string {
        case "R": return Right
        case "D": return Down
        case "L": return Left
        case "U": return Up
        default: fatalError("Unexpected direction")
        }
    }
}

class CubeSide: Equatable, CustomStringConvertible, Hashable {
    let name: String

    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    let sideSize: Int

    init(name: String, x: Int, y: Int, sideSize: Int) {
        self.name = name
        xRange = (x * sideSize)...((x + 1) * sideSize - 1)
        yRange = (y * sideSize)...((y + 1) * sideSize - 1)
        self.sideSize = sideSize
    }

    func contains(point: Point) -> Bool {
        xRange.contains(point.x) && yRange.contains(point.y)
    }

    func colOffset(position: Point) -> Int {
        xRange.enumerated().first { offset, col in col == position.x}!.offset
    }

    func rowOffset(position: Point) -> Int {
        yRange.enumerated().first { offset, row in row == position.y}!.offset
    }

    func inverseOffset(offset: Int) -> Int {
        xRange.count - 1 - offset
    }

    func rotate(point: Point, angle: Int) -> Point {
        switch angle {
        case 0, 360:
            return point
        case 90:
            let colIdx = colOffset(position: point)
            let rowIdx = rowOffset(position: point)
            return Point(
                    x: col(idx: inverseOffset(offset: rowIdx)),
                    y: row(idx: colIdx)
            )
        case 180:
            let colIdx = inverseOffset(offset: colOffset(position: point))
            let rowIdx = inverseOffset(offset: rowOffset(position: point))
            return Point(x: col(idx: colIdx), y: row(idx: rowIdx))
        case 270:
            let colIdx = colOffset(position: point)
            let rowIdx = rowOffset(position: point)
            return Point(
                    x: col(idx: rowIdx),
                    y: row(idx: inverseOffset(offset: colIdx))
            )
        default:
            fatalError("Unexpected turn angle")
        }
    }

    func col(idx: Int) -> Int {
        xRange.first! + idx
    }

    func row(idx: Int) -> Int {
        yRange.first! + idx
    }

    static func ==(lhs: CubeSide, rhs: CubeSide) -> Bool {
        lhs.xRange == rhs.xRange && lhs.yRange == rhs.yRange
    }

    var description: String {
        "\(name) (x: \(xRange), y: \(yRange))"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(xRange)
        hasher.combine(yRange)
    }
}

typealias SideConfig = [Dir: (CubeSide, Int)]
struct CubeSideConfig {
    let side: CubeSide
    let config: [Dir: (CubeSide, Int)]

    static func edgeConfig(side: CubeSide, configMap: [Dir: (CubeSide, Int)]) -> CubeSideConfig {
        assert(configMap.count == 4, "All directions need to be defined")
        return CubeSideConfig(side: side, config: configMap)
    }
}

struct CubeLayout {
    private var configuration: [CubeSide: SideConfig] = [:]

    func getFaceAngle(sourceSide: CubeSide, edge: Dir) -> (CubeSide, Int) {
        configuration[sourceSide]![edge]!
    }

    init(front: CubeSideConfig, rear: CubeSideConfig,
         top: CubeSideConfig, bottom: CubeSideConfig,
         left: CubeSideConfig, right: CubeSideConfig) {
        configuration[front.side] = front.config
        configuration[rear.side] = rear.config
        configuration[top.side] = top.config
        configuration[bottom.side] = bottom.config
        configuration[left.side] = left.config
        configuration[right.side] = right.config
    }

    func whichCubeFace(point: Point) -> CubeSide {
        let foundSide = configuration.keys.first { face in
            face.contains(point: point)
        }

        if let foundSide {
            return foundSide
        } else {
            fatalError("Side for point: \(point) not found")
        }
    }
}

class MonkeyMap {
    func calculatePlanePath(input: [String]) -> Int {
        let (rows, path, blocked) = parseInput(input: input)

        var position = Point(x: rows.first!.lowerBound, y: 0)
        var facing: Dir = .Right

        for step in path {
            print("Position: \(position.moveBy(x: 1, y: 1)), facing: \(facing); next move: \(step)")

            let maybeNumber = Int(step)

            if let number = maybeNumber {
                // steps
                for _ in 0..<number {
                    let nextPoint = nextPositionCandidate(position: position, facing: facing, rows: rows)
                    if blocked.contains(nextPoint) {
                        break
                    } else {
                        position = nextPoint
                    }
                }
            } else {
                // change dir
                let newDir = facing.turn(string: step)

                facing = newDir
            }
        }

        return 1000 * (position.y + 1) + 4 * (position.x + 1) + facing.rawValue
    }

    func calculateCubePath(input: [String], cube: CubeLayout) -> Int {
        let (rows, path, blocked) = parseInput(input: input)

        var position = Point(x: rows.first!.lowerBound, y: 0)
        var facing: Dir = .Right

        for step in path {
            print("Position: \(position.moveBy(x: 1, y: 1)), facing: \(facing); next move: \(step)")
            let maybeNumber = Int(step)

            if let number = maybeNumber { // steps
                for _ in 0..<number {
                    let (nextPoint, nextDir) = nextPositionDirectionCandidate(position: position, facing: facing, rows: rows, cubeFaces: cube)

                    if blocked.contains(nextPoint) {
                        break
                    } else {
                        position = nextPoint
                        facing = nextDir
                    }
                }

            } else { // change dir
                let newDir = facing.turn(string: step)
                facing = newDir
            }

        }

        return 1000 * (position.y + 1) + 4 * (position.x + 1) + facing.rawValue
    }

    private func nextPositionDirectionCandidate(position: Point, facing: Dir, rows: [ClosedRange<Int>], cubeFaces: CubeLayout) -> (Point, Dir) {
        let side = cubeFaces.whichCubeFace(point: position)

        var nextPosition = position
        var nextDir = facing

        // check if new position is on the same side
        let positionCandidate = facing.move(point: position)
        if side.contains(point: positionCandidate) {
            return (positionCandidate, facing)
        }

        let (nextSide, _) = cubeFaces.getFaceAngle(sourceSide: side, edge: facing)
        (nextPosition, nextDir) = determinePosition(current: position, currentSide: side, sideEdge: facing, config: cubeFaces)

        print("\tChanged side from: \(side.name) -> \(nextSide.name)")
        return (nextPosition, nextDir)
    }

    private func determinePosition(current: Point, currentSide: CubeSide, sideEdge: Dir, config: CubeLayout) -> (Point, Dir) {
        var nextPosition = current
        var nextDir = sideEdge

        let (nextSide, angle) = config.getFaceAngle(sourceSide: currentSide, edge: sideEdge)

        let colIdx = currentSide.colOffset(position: current)
        let rowIdx = currentSide.rowOffset(position: current)
        switch sideEdge {
            case .Up:
                nextPosition = Point(
                        x: nextSide.col(idx: colIdx),
                        y: nextSide.yRange.last!
                )
            case .Down:
                nextPosition = Point(
                        x: nextSide.col(idx: colIdx),
                        y: nextSide.yRange.first!
                )
            case .Left:
                nextPosition = Point(
                        x: nextSide.xRange.last!,
                        y: nextSide.row(idx: rowIdx)
                )
            case .Right:
                nextPosition = Point(
                        x: nextSide.xRange.first!,
                        y: nextSide.row(idx: rowIdx)
                )
        }

        nextPosition = nextSide.rotate(point: nextPosition, angle: 360 - angle)
        nextDir = sideEdge.turn(degrees: 360 - angle)

        return (nextPosition, nextDir)
    }

    private func nextPositionCandidate(position: Point, facing: Dir, rows: [ClosedRange<Int>]) -> Point {
        var nextPoint = position
        let (x, y) = (position.x, position.y)

        switch facing {
            case .Right:
                let range = rows[position.y]

                var newX = x + 1
                if newX > range.upperBound {
                    newX = range.lowerBound
                }
                nextPoint = Point(x: newX, y: y)

            case .Down:
                var newY = y
                var range: ClosedRange<Int>? = nil

                repeat  {
                    newY += 1

                    if newY >= rows.count {
                        newY = 0
                    }

                    range = rows[newY]
                } while !range!.contains(position.x)

                nextPoint = Point(x: position.x, y: newY)

            case .Left:
                let range = rows[y]

                var newX = position.x - 1
                if newX < range.lowerBound {
                    newX = range.upperBound
                }
                nextPoint = Point(x: newX, y: y)

            case .Up:
                var newY = y
                var range: ClosedRange<Int>? = nil

                repeat  {
                    newY -= 1

                    if newY < 0 {
                        newY = rows.count - 1
                    }

                    range = rows[newY]
                } while !range!.contains(position.x)

                nextPoint = Point(x: position.x, y: newY)
        }
        return nextPoint
    }

    private func parseInput(input: [String]) -> ([ClosedRange<Int>], [String], [Point]) {
        var blocked: [Point] = []
        var rows: [ClosedRange<Int>] = []

        input[0..<input.count - 2].enumerated().forEach { y, line in
            var lowestX = Int.max
            var highestX = -1
            line.enumerated().forEach { x, char in
                if char == Character("#") {
                    blocked.append(Point(x: x, y: y))
                }

                if char != Character(" ") {
                    if x < lowestX {
                        lowestX = x
                    }

                    if x > highestX {
                        highestX = x
                    }
                }
            }
            rows.append(lowestX...highestX)
        }

        let pathLine = input.last!
        let captures = Util.multipleRegexMatch(string: pathLine, pattern: #"(\d+|[A-Z])"#)

        let path: [String] = captures.map { $0[1] }
        print(path)

        return (rows, path, blocked)
    }
}


