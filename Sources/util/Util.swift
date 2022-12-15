import Foundation

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

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

class Util {
    static func firstRegexMatch(string: String, pattern: String) -> [String]? {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        let matches = regex.matches(in: string, range: range)

        if let match = matches.first {
            var captures: [String] = []
            for rangeIdx in 0..<match.numberOfRanges {
                captures.append(
                    String(string[Range(match.range(at: rangeIdx), in: string)!])
                )
            }
            return captures
        } else {
            return nil
        }
    }

    static func timed<T>(description: String, logic: ()->T) -> T {
        var startTime = DispatchTime.now().uptimeNanoseconds

        defer {
            let diff = DispatchTime.now().uptimeNanoseconds - startTime
            print("Processed: \(description) in \(diff/1_000_000)ms")
        }

        return logic()
    }
}
