import Foundation

class UnstableDiffusion {
    enum Dir: Int {
        case north
        case south
        case west
        case east

        func next() -> Dir {
            Dir(rawValue: (rawValue + 1) % 4)!
        }
    }

    func diffuseElves(input: [String], roundLimit: Int = Int.max) -> (Int, Int) {
        let (width, height, elves) = parseInput(input: input)

        var positions = Set(elves)
        var startingDir = Dir.north
//        printGrid(msg: "Initial positions", width: width, height: height, positions: positions)

        var round = 0
        var anyMovementHappened = true

        while anyMovementHappened && round < roundLimit {
            round += 1
            var nextPositions: [Point: Point] = [:]

            positions.forEach { elf in
                let proposal = proposeNewPosition(elf: elf, direction: startingDir, positions: positions, width: width, height: height)
                nextPositions[elf] = proposal
            }

            let posCount = countNextPositions(nextPositions: nextPositions)
            nextPositions.forEach { prev, next in
                if posCount[next] ?? 0 > 1 {
                    nextPositions[prev] = prev
                }
            }

            positions = Set(nextPositions.values)
            startingDir = startingDir.next()

            anyMovementHappened = nextPositions.contains { prev, next in
                prev != next
            }

//            printGrid(msg: "Positions after round: \(round)", width: width, height: height, positions: positions)
        }

        let xs = positions.map { $0.x }
        let ys = positions.map { $0.y }

        let gridSize = (xs.min()!...xs.max()!).count * (ys.min()!...ys.max()!).count
        return (gridSize - positions.count, round)
    }

    private func countNextPositions(nextPositions: [Point: Point]) -> [Point: Int] {
        var posCount: [Point: Int] = [:]
        nextPositions.forEach { prev, next in
            let nextCount = posCount[next] ?? 0
            posCount[next] = nextCount + 1
        }
        return posCount
    }

    private func printGrid(msg: String, width: Int, height: Int, positions: Set<Point>) {
        print(msg)
        for y in 0..<height {
            var line = ""
            for x in 0..<width {
                if positions.contains(Point(x: x, y: y)) {
                    line.append("#")
                } else {
                    line.append(".")
                }
            }
            print(line)
        }
    }

    private func proposeNewPosition(elf: Point, direction: Dir, positions: Set<Point>, width: Int, height: Int) -> Point {
        let proposals = proposalsToCheck(elf: elf)

        let otherElfInArea = proposals.values.contains { points in
            points.contains { point in
                positions.contains(point)
            }
        }

        // no movement
        if !otherElfInArea {
            return elf
        }

        var dir = direction
        var pointToMove = elf

        repeat {
            let pointsToCheck = proposals[dir]!
            let otherElfInArea = pointsToCheck.contains { point in
                positions.contains(point)
            }

            if !otherElfInArea {
                pointToMove = pointsToCheck.first!
                break
            }

            dir = dir.next()
        } while dir != direction

        return pointToMove
    }

    private func proposalsToCheck(elf: Point) -> [Dir: [Point]] {
        let northPoint = elf.moveBy(y: -1)
        let northPoints = [northPoint, northPoint.moveBy(x: -1), northPoint.moveBy(x: 1)]

        let southPoint = elf.moveBy(y: +1)
        let southPoints = [southPoint, southPoint.moveBy(x: -1), southPoint.moveBy(x: 1)]

        let west = elf.moveBy(x: -1)
        let westPoints = [west, west.moveBy(y: -1), west.moveBy(y: 1)]

        let eastPoint = elf.moveBy(x: 1)
        let eastPoints = [eastPoint, eastPoint.moveBy(y: -1), eastPoint.moveBy(y: 1)]

        let points: [Dir: [Point]] = [
            .north : northPoints,
            .south : southPoints,
            .west : westPoints,
            .east : eastPoints,
        ]
        return points
    }


    private func parseInput(input: [String]) -> (Int, Int, [Point]) {
        let height = input.count
        var width = -1
        var elves: [Point] = []

        input.enumerated().forEach { y, line in
            if width < 0 {
                width = line.count
            }

            line.enumerated().forEach { x, char in
                if char == "#" {
                    elves.append(Point(x: x, y: y))
                }
            }
        }
        return (width, height, elves)
    }
}