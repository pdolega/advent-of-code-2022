import Foundation


class RegolithReservoir {
    func simulateSandBottomless(input: [String]) -> Int {
        var filledSpace = parseInput(input: input)
        let minY = filledSpace.map { $0.y }.min { $0 > $1 }!

        let startPoint = Point(x: 500, y: 0)
        var currentPosition = Point(x: startPoint.x, y: startPoint.y)

        var sandCount = 0

        while currentPosition.y <= minY {
            let candidate = currentPosition.moveBy(y: 1)

            if !filledSpace.contains(candidate) {
                currentPosition = candidate
            } else if !filledSpace.contains(candidate.moveBy(x: -1)) {
                currentPosition = candidate.moveBy(x: -1)
            } else if !filledSpace.contains(candidate.moveBy(x: 1)) {
                currentPosition = candidate.moveBy(x: 1)
            } else {
                filledSpace.insert(currentPosition)
                sandCount += 1

                currentPosition = startPoint
            }
        }

        return sandCount
    }

    func simulateSandCaveFloor(input: [String]) -> Int {
        var filledSpace = parseInput(input: input)
        let minY = filledSpace.map { $0.y }.min { $0 > $1 }!
        let bottomY = minY + 2

        let startPoint = Point(x: 500, y: 0)
        var currentPosition = Point(x: startPoint.x, y: startPoint.y)

        var sandCount = 0

        while !filledSpace.contains(startPoint) {
            let candidate = currentPosition.moveBy(y: 1)

            if candidate.y == bottomY {
                filledSpace.insert(currentPosition)
                sandCount += 1

                currentPosition = startPoint
                continue
            }

            if !filledSpace.contains(candidate) {
                currentPosition = candidate
            } else if !filledSpace.contains(candidate.moveBy(x: -1)) {
                currentPosition = candidate.moveBy(x: -1)
            } else if !filledSpace.contains(candidate.moveBy(x: 1)) {
                currentPosition = candidate.moveBy(x: 1)
            } else {
                filledSpace.insert(currentPosition)
                sandCount += 1

                currentPosition = startPoint
            }
        }

        return sandCount
    }

    private func parseInput(input: [String]) -> Set<Point> {
        let pointLines = parsePointLines(input: input)
        let filledSpaceArr = fillSpace(pointLines: pointLines)
//        print("Parsed point lines: \(filledSpaceArr)")

        return Set(filledSpaceArr)
    }

    private func parsePointLines(input: [String]) -> [[Point]] {
        var pointLines: [[Point]] = []
        input.forEach { line in
            var points: [Point] = []

            let captures = Util.multipleRegexMatch(string: line, pattern: #"(\d+,\d+)"#)
            captures.flatMap { $0[1...] }.forEach { string in
                let nums = string.components(separatedBy: ",")
                points.append(Point(x: Int(nums.first!)!, y: Int(nums.last!)!))
            }
            pointLines.append(points)
        }
        return pointLines
    }

    private func fillSpace(pointLines: [[Point]]) -> [Point] {
        var filledSpace: [Point] = []
        pointLines.forEach { line in
            var prevPoint: Point = line.first!

            for point in line[1...] {
                if prevPoint.x == point.x {
                    let x = prevPoint.x
                    let startY = min(prevPoint.y, point.y)
                    let endY = max(prevPoint.y, point.y)
                    filledSpace.append(contentsOf: (startY...endY).map { Point(x: x, y: $0) })
                } else if prevPoint.y == point.y {
                    let y = prevPoint.y
                    let startX = min(prevPoint.x, point.x)
                    let endX = max(prevPoint.x, point.x)
                    filledSpace.append(contentsOf: (startX...endX).map { Point(x: $0, y: y) })
                } else {
                    assertionFailure("Either x or y should be same for 2 points: \(prevPoint) & \(point)")
                }

                prevPoint = point
            }
        }

        return filledSpace
    }
}