import Foundation

import Foundation
import XCTest

@testable import Source

final class CampCleanupTest: XCTestCase {

    // 1st part
    func testSimpleCompleteOverlap() throws {
        XCTAssertEqual(
                CampCleanup().countCompleteOverlap(
                        assignments: [
                            ("2-4","6-8"),
                            ("2-3","4-5"),
                            ("5-7","7-9"),
                            ("2-8","3-7"),
                            ("6-6","4-6"),
                            ("2-6","4-8"),
                        ]),
                2
        )
    }

    func testRealInputCompleteOverlap() throws {
        XCTAssertEqual(
                CampCleanup().countCompleteOverlap(
                        assignments: try readAssignments()
                ),
                515
        )
    }

    // 2nd part
    func testSimplePartialOverlap() throws {
        XCTAssertEqual(
                CampCleanup().countPartialOverlap(
                        assignments: [
                            ("2-4","6-8"),
                            ("2-3","4-5"),
                            ("5-7","7-9"),
                            ("2-8","3-7"),
                            ("6-6","4-6"),
                            ("2-6","4-8"),
                        ]
                ),
                4
        )
    }

    func testRealInputPartialOverlap() throws {
        XCTAssertEqual(
                CampCleanup().countPartialOverlap(
                        assignments: try readAssignments()
                ),
                883
        )
    }

    private func readAssignments() throws -> [(String, String)] {
        let lines = try TestUtil.readInputLines(fileName: "day04.txt")

        return lines.map { line in
            let assignments = line.components(separatedBy: ",")
            assert(assignments.count == 2, "There should be to sets of assignments in each row")
            return (assignments.first!, assignments.last!)
        }
    }
}

