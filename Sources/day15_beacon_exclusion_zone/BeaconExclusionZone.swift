import Foundation


class BeaconExclusionZone {

    struct SensorRange {
        let sensor: Point
        let beaconInRange: Point
        let distanceToBeacon: Int
    }

    func countCoverageAtRow(input: [String], y: Int) -> Int {
        let pointsRange = parseInput(input: input)
        let coverage = calculateCoverageAtRow(pointsRange: pointsRange, rowToCheck: y)

        var count = coverage.reduce(0) { sum, range in
            sum + range.count
        }

        Set(pointsRange.map { $0.beaconInRange }).forEach { beacon in
            if beacon.y == y {
                count -= 1
            }
        }

        return count
    }

    func calculateTuningFrequency(input: [String], mapRange: ClosedRange<Int>) -> Int {
        let pointsRange = parseInput(input: input)

        let pointNotCovered = Util.timed(description: "Finding coverage") {
            findNotCoveredPoint(mapRange: mapRange, pointsRange: pointsRange)!
        }

        return pointNotCovered.x * 4_000_000 + pointNotCovered.y
    }

    private func findNotCoveredPoint(mapRange: ClosedRange<Int>, pointsRange: [SensorRange]) -> Point? {
        for y in mapRange {
            let rowCoverage = calculateCoverageAtRow(pointsRange: pointsRange, rowToCheck: y)
            assert(rowCoverage.count <= 2, "Count should be at most 2 (row: \(y))")

            var foundGap = true
            rowCoverage.forEach { rangeToCheck in
                if rangeToCheck.lowerBound <= mapRange.lowerBound && rangeToCheck.upperBound >= mapRange.upperBound {
                    foundGap = false
                }
            }

            if foundGap == true {
                print("Found gap at row: \(y) [ranges: \(rowCoverage)]")
                return Point(x: rowCoverage.first!.upperBound + 1, y: y)
            }
        }

        return nil
    }

    private func calculateCoverageAtRow(pointsRange: [SensorRange], rowToCheck: Int) -> [ClosedRange<Int>] {
        let rangesAtRow = pointsRange.map { calculateRangeForRow(point: $0.sensor, scanRange: $0.distanceToBeacon, y: rowToCheck) }
                .filter { $0 != nil }
                .map { $0! }
                .sorted { $0.lowerBound < $1.lowerBound }

        if rangesAtRow.count <= 1 {
            return rangesAtRow
        } else {
            return normalizeRanges(rangesAtRow: rangesAtRow)
        }
    }

    private func normalizeRanges(rangesAtRow: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        assert(rangesAtRow.count >= 2, "Ranges to normalize need to have at least 2 intervals")
        var newRanges: [ClosedRange<Int>] = [rangesAtRow.first!]

        rangesAtRow.forEach { range in
            let prevRange = newRanges.last!

            if prevRange.upperBound >= range.lowerBound - 1 {
                newRanges.removeLast()
                let maxX = max(range.upperBound, prevRange.upperBound)
                newRanges.append(prevRange.lowerBound...maxX)
            } else {
                newRanges.append(range)
            }
        }

        return newRanges
    }

    private func distance(pointA: Point, pointB: Point) -> Int {
        let xDist = abs(pointB.x - pointA.x)
        let yDist = abs(pointB.y - pointA.y)

        return xDist + yDist
    }

    private func calculateRangeForRow(point: Point, scanRange: Int, y: Int) -> ClosedRange<Int>? {
        let yRange = abs(point.y - y)

        if scanRange < yRange {
            return nil
        } else {
            let leftRange = point.x - (scanRange - yRange)
            let rightRange = point.x + (scanRange - yRange)

            return leftRange...rightRange
        }
    }

    private func parseInput(input: [String]) -> [SensorRange] {
        var sensorRanges: [SensorRange] = []

        input.forEach { line in
            let (sensor, beacon) = parse(line: line)!
            sensorRanges.append(
                    SensorRange(sensor: sensor, beaconInRange: beacon, distanceToBeacon: distance(pointA: sensor, pointB: beacon))
            )
        }

        return sensorRanges
    }

    private func parse(line: String) -> (Point, Point)? {
        if let captures = Util.firstRegexMatch(string: line, pattern: #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#) {
            let sensorPoint = Point(x: Int(captures[1])!, y: Int(captures[2])!)
            let beaconPoint = Point(x: Int(captures[3])!, y: Int(captures[4])!)
            return (sensorPoint, beaconPoint)
        } else {
            return nil
        }
    }
}