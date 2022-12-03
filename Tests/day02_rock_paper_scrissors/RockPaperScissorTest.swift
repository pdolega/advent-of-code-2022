import XCTest

@testable import Source

final class RockPaperScissorTest: XCTestCase {

    // 1st part
    func testSimple1st() throws {
        XCTAssertEqual(
                RockPaperScissorsStrategy().calculate1stResult(
                    strategy: [
                        (.rock, .paper),
                        (.paper, .rock),
                        (.scissors, .scissors)
                    ]
                ),
                15
        )
    }

    func testTopRealInput1st() throws {
        XCTAssertEqual(
                RockPaperScissorsStrategy().calculate1stResult(
                        strategy: try read1stStrategyList()
                ),
                8_890
        )
    }

    // 2nd part
    func testSimple2nd() throws {
        XCTAssertEqual(
                RockPaperScissorsStrategy().calculate2ndResult(
                        strategy: [
                            (.rock, .draw),
                            (.paper, .lost),
                            (.scissors, .won)
                        ]
                ),
                12
        )
    }

    func testTopRealInput2nd() throws {
        XCTAssertEqual(
                RockPaperScissorsStrategy().calculate2ndResult(
                        strategy: try read2ndStrategyList()
                ),
                10_238
        )
    }

    private func read1stStrategyList() throws -> [(Choice, Choice)] {
        return try readLines { string in Choice.parse(string: string) }
    }

    private func read2ndStrategyList() throws -> [(Choice, Outcome)] {
        return try readLines { string in Outcome.parse(string: string) }
    }

    private func readLines<T>(parse2nd: (String) -> T?) throws -> [(Choice, T)] {
        let lines = try TestUtil.readInputLines(fileName: "day02.txt")
        return lines.map { (element: String) -> (Choice, T) in
            let roundChoices = element.components(separatedBy: " ")

            return (
                    Choice.parse(string: roundChoices[0])!,
                    parse2nd(roundChoices[1])!
            )
        }
    }
}

