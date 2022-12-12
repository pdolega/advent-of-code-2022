import Foundation

import Foundation
import XCTest

@testable import Source

final class HillClimbTest: XCTestCase {

    private let testData = """
                           Sabqponm
                           abcryxxl
                           accszExk
                           acctuvwj
                           abdefghi
                           """

    // 1st part
    func testSimpleSinglePath() throws {
        XCTAssertEqual(
                HillClimb().findShortestPath(input: testData.components(separatedBy: "\n")),  31
        )
    }

    func testRealInputSinglePath() throws {
        XCTAssertEqual(
                HillClimb().findShortestPath(input: try readLines()), 352
        )
    }

    // 2nd part
    func testSimpleAllPaths() throws {
        XCTAssertEqual(
                HillClimb().findShortestFromAllPaths(input: testData.components(separatedBy: "\n")),  29
        )
    }

    func testRealInputAllPaths() throws {
        XCTAssertEqual(
                HillClimb().findShortestFromAllPaths(input: try readLines()), 345
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day12.txt")
    }
}