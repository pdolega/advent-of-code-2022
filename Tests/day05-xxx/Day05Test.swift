import Foundation

import Foundation
import XCTest

@testable import Source

final class Day05XXXTest: XCTestCase {

    // 1st part
    func testSimpleCompleteOverlap() throws {
        XCTAssertEqual(
                Day05XXX().countCompleteOverlap(
                        lines: [
                        ]
                ),
                2
        )
    }

    func testRealInputCompleteOverlap() throws {
        XCTAssertEqual(
                Day05XXX().countCompleteOverlap(
                        lines: try readLines()
                ),
                515
        )
    }

    // 2nd part
//    func testSimplePartialOverlap() throws {
//        XCTAssertEqual(
//                CampCleanup().countPartialOverlap(
//                        assignments: [
//                            ("2-4","6-8"),
//                            ("2-3","4-5"),
//                            ("5-7","7-9"),
//                            ("2-8","3-7"),
//                            ("6-6","4-6"),
//                            ("2-6","4-8"),
//                        ]
//                ),
//                4
//        )
//    }
//
//    func testRealInputPartialOverlap() throws {
//        XCTAssertEqual(
//                CampCleanup().countPartialOverlap(
//                        assignments: try readAssignments()
//                ),
//                883
//        )
//    }

    private func readLines() throws -> [String] {
        let lines = try TestUtil.readInputLines(fileName: "day05.txt")
        return lines
    }
}

