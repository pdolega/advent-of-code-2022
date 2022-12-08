import Foundation

import Foundation
import XCTest

@testable import Source

final class TreeHouseTest: XCTestCase {

    private let testInput = """
                            30373
                            25512
                            65332
                            33549
                            35390
                            """.components(separatedBy: "\n")

    // 1st part
    func testSimpleTreeVisibility() throws {
        XCTAssertEqual(
                TreeHouse().countTreesVisibleFromOutside(input: testInput),  21
        )
    }

    func testRealInputTreeVisibility() throws {
        XCTAssertEqual(
                TreeHouse().countTreesVisibleFromOutside(input: try readLines()), 1_792
        )
    }

    // 2nd part
    func testSimpleMaxScenicScore() throws {
        XCTAssertEqual(
                TreeHouse().maxScenicScore(input: testInput),  8
        )
    }

    func testRealInputMaxScenicScore() throws {
        XCTAssertEqual(
                TreeHouse().maxScenicScore(input: try readLines()), 334_880
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day08.txt")
    }
}