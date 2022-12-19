import Foundation

import Foundation
import XCTest

@testable import Source

final class MineralRobots: XCTestCase {

    private let testData = """
                           Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
                           Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
                           """

//     1st part
    func testSimpleShort() throws {
        XCTAssertEqual(
                MineralRobots().calculateQualityLevels(input: testData.components(separatedBy: "\n")), 33
        )
    }

//    func testRealInputShort() throws {
//        XCTAssertEqual(
//                MineralRobots().calculateQualityLevels(input: try readLines()),  1_599
//        )
//    }

    // 2nd part
//    func testSimpleLong() throws {
//        XCTAssertEqual(
//                MineralRobots().calculateMaxGeodes(input: testData.components(separatedBy: "\n")),  56 * 62
//        )
//    }

//    func testRealInputLong() throws {
//        XCTAssertEqual(
//                MineralRobots().calculateMaxGeodes(input: try readLines()),  14112
//        )
//    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day19.txt")
    }
}