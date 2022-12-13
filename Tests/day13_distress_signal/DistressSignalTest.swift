import Foundation

import Foundation
import XCTest

@testable import Source

final class DistressSignalTest: XCTestCase {

    private let testData = """
                           [1,1,3,1,1]
                           [1,1,5,1,1]

                           [[1],[2,3,4]]
                           [[1],4]

                           [9]
                           [[8,7,6]]

                           [[4,4],4,4]
                           [[4,4],4,4,4]

                           [7,7,7,7]
                           [7,7,7]

                           []
                           [3]

                           [[[]]]
                           [[]]

                           [1,[2,[3,[4,[5,6,7]]]],8,9]
                           [1,[2,[3,[4,[5,6,0]]]],8,9]
                           """

    // 1st part
    func testSimpleSinglePath() throws {
        XCTAssertEqual(
                DistressSignal().countCorrectOrder(input: testData.components(separatedBy: "\n")),  13
        )
    }

    func testRealInputSinglePath() throws {
        XCTAssertEqual(
                DistressSignal().countCorrectOrder(input: try readLines()), 5_013
        )
    }

    // 2nd part
    func testSimpleAllPaths() throws {
        XCTAssertEqual(
                DistressSignal().calculateDividerInsertion(input: testData.components(separatedBy: "\n")),  140
        )
    }

    func testRealInputAllPaths() throws {
        XCTAssertEqual(
                DistressSignal().calculateDividerInsertion(input: try readLines()), 25_038
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day13.txt")
    }
}