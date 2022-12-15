import Foundation

import Foundation
import XCTest

@testable import Source

final class RegolithReservoirTest: XCTestCase {

    private let testData = """
                           498,4 -> 498,6 -> 496,6
                           503,4 -> 502,4 -> 502,9 -> 494,9
                           """

    // 1st part
    func testSimpleBottomless() throws {
        XCTAssertEqual(
                RegolithReservoir().simulateSandBottomless(input: testData.components(separatedBy: "\n")),  24
        )
    }

    func testRealInputBottomless() throws {
        XCTAssertEqual(
                RegolithReservoir().simulateSandBottomless(input: try readLines()), 1_003
        )
    }

    // 2nd part
    func testSimpleCaveFloor() throws {
        XCTAssertEqual(
                RegolithReservoir().simulateSandCaveFloor(input: testData.components(separatedBy: "\n")),  93
        )
    }

    func testRealInputCaveFloor() throws {
        XCTAssertEqual(
                RegolithReservoir().simulateSandCaveFloor(input: try readLines()), 25_771
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day14.txt")
    }
}