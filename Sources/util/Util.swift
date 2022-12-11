import Foundation

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
}
