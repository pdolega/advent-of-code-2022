import Foundation

import Foundation
import XCTest

@testable import Source

final class BlizzardBasinTest: XCTestCase {

    private let testData = """
                           #.######
                           #>>.<^<#
                           #.<..<<#
                           #>v.><>#
                           #<^v^^>#
                           ######.#
                           """

    //  1st part
    func testSimpeTravelOnce() throws {
        XCTAssertEqual(
            BlizzardBasin().findPath(input: testData.components(separatedBy: "\n")), 18
        )
    }

    func testRealInputTravelOnce() throws {
        XCTAssertEqual(
            BlizzardBasin().findPath(input: try readLines()),  251
        )
    }

    // 2nd part
    func testSimpleTravelStages() throws {
        XCTAssertEqual(
                BlizzardBasin().findPath(input: testData.components(separatedBy: "\n"), tripLegs: 3), 54
        )
    }

    func testRealInputTravelStages() throws {
        XCTAssertEqual(
            BlizzardBasin().findPath(input: try readLines(), tripLegs: 3),  758
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day24.txt")
    }
}