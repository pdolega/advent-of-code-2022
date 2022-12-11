import Foundation

import Foundation
import XCTest

@testable import Source

final class MonkeyKeepAwayTest: XCTestCase {

    private let testData = """
                           Monkey 0:
                             Starting items: 79, 98
                             Operation: new = old * 19
                             Test: divisible by 23
                               If true: throw to monkey 2
                               If false: throw to monkey 3

                           Monkey 1:
                             Starting items: 54, 65, 75, 74
                             Operation: new = old + 6
                             Test: divisible by 19
                               If true: throw to monkey 2
                               If false: throw to monkey 0

                           Monkey 2:
                             Starting items: 79, 60, 97
                             Operation: new = old * old
                             Test: divisible by 13
                               If true: throw to monkey 1
                               If false: throw to monkey 3

                           Monkey 3:
                             Starting items: 74
                             Operation: new = old + 3
                             Test: divisible by 17
                               If true: throw to monkey 0
                               If false: throw to monkey 1
                           """

    // 1st part
    func testSimpleShort() throws {
        XCTAssertEqual(
                MonkeyKeepAway().calculateInspections(input: testData.components(separatedBy: "\n"), divider: 3, rounds: 20),  10_605
        )
    }

    func testRealInputShort() throws {
        XCTAssertEqual(
                MonkeyKeepAway().calculateInspections(input: try readLines(), divider: 3, rounds: 20), 55_216
        )
    }

    // 2nd part
    func testSimpleLong() throws {
        XCTAssertEqual(
                MonkeyKeepAway().calculateInspections(input: testData.components(separatedBy: "\n")),  2_713_310_158
        )
    }

    func testRealInputLong() throws {
        XCTAssertEqual(
                MonkeyKeepAway().calculateInspections(input: try readLines()), 12_848_882_750
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day11.txt")
    }
}