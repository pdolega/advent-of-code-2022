import Foundation

class LineMovement {

    struct Point: Equatable, Hashable {
        var x: Int
        var y: Int

        func isAdjacent(other: Point) -> Bool {
            abs(x - other.x) <= 1 && abs(y - other.y) <= 1
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }

        static func == (lhs: Point, rhs: Point) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }

    func calculateSingleTailMovement(input: [String]) -> Int {
        var headPosition = Point(x: 0, y: 0)
        var tailPosition = Point(x: 0, y: 0)

        var tailPath = Set([tailPosition])

        input.forEach { line in
            let move = line.components(separatedBy: " ")
            let direction = move[0]
            let steps = Int(move[1])!

            for _ in 0..<steps {
                headPosition = calculateMoveFromCode(position: headPosition, directionCode: direction)

                if !headPosition.isAdjacent(other: tailPosition) {
                    let newTailPosition = newTailPosition(headPosition: headPosition, tailPosition: tailPosition)
                    tailPath.insert(newTailPosition)
                    tailPosition = newTailPosition
                }

//                print("Head:: (\(headPosition.x), \(headPosition.y)) -> Tail:: (\(tailPosition.x), \(tailPosition.y)) [Move: \(move)]")
            }

//            print()
        }

        return tailPath.count
    }


    func calculateWholeLineTailMovement(input: [String]) -> Int {
        var linePositions = Array.init(repeating: Point(x: 0, y: 0), count: 10)
        var tailPath = Set<Point>()

        input.forEach { line in
            let move = line.components(separatedBy: " ")
            let direction = move[0]
            let steps = Int(move[1])!

            for _ in 0..<steps {
                let newHeadPosition = calculateMoveFromCode(position: linePositions.first!, directionCode: direction)
                linePositions[0] = newHeadPosition

                linePositions.enumerated().forEach { index, nextPosition in
                    if index == 0 {
                        return
                    }

                    let prevPosition = linePositions[index-1]
                    if !prevPosition.isAdjacent(other: nextPosition) {
                        let newNextPosition = newTailPosition(headPosition: prevPosition, tailPosition: nextPosition)
                        linePositions[index] = newNextPosition
                    }
                }

                tailPath.insert(linePositions.last!)
//                print("Head:: (\(linePositions.first!.x), \(linePositions.first!.y)) -> " +
//                        "Tail:: (\(linePositions.last!.x), \((linePositions.last!.y)) [Move: \(move)]")
            }

//            print()
        }

        return tailPath.count
    }

    private func calculateMoveFromCode(position: Point, directionCode: String) -> Point {
        var newPosition = position

        switch directionCode {
            case "R":
                newPosition.x += 1
            case "L":
                newPosition.x += -1
            case "U":
                newPosition.y += 1
            case "D":
                newPosition.y -= 1
            default:
                assertionFailure("Incorrect direction: \(directionCode)")
        }

        return newPosition
    }

    private func newTailPosition(headPosition: Point, tailPosition: Point) -> Point {
        var dX = 0, dY = 0

        let diffX = headPosition.x - tailPosition.x
        let diffY = headPosition.y - tailPosition.y

        if abs(diffX) > 1 || (abs(diffX) > 0 && abs(diffY) > 0) {
            dX = diffX > 0 ? 1 : -1
        }

        if abs(diffY) > 1 || (abs(diffX) > 0 && abs(diffY) > 0) {
            dY = diffY > 0 ? 1 : -1
        }

        let newTailPosition = Point(
            x: tailPosition.x + dX,
            y: tailPosition.y + dY
        )
        return newTailPosition
    }
}