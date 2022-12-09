import Foundation

import Foundation
import XCTest

@testable import Source

final class LineMovementTest: XCTestCase {

    // 1st part
    func testSimpleHeadTail() throws {
        XCTAssertEqual(
                LineMovement().calculateSingleTailMovement(input: """
                                                                  R 4
                                                                  U 4
                                                                  L 3
                                                                  D 1
                                                                  R 4
                                                                  D 1
                                                                  L 5
                                                                  R 2
                                                                  """.components(separatedBy: "\n")),  13
        )
    }

    func testRealInputHeadTail() throws {
        XCTAssertEqual(
                LineMovement().calculateSingleTailMovement(input: try readLines()), 6_314
        )
    }

    // 2nd part
    func testSimpleWholeLine() throws {
        XCTAssertEqual(
                LineMovement().calculateWholeLineTailMovement(input:  """
                                                                      R 5
                                                                      U 8
                                                                      L 8
                                                                      D 3
                                                                      R 17
                                                                      D 10
                                                                      L 25
                                                                      U 20
                                                                      """.components(separatedBy: "\n")),  36
        )
    }

    func testRealInputWholeLine() throws {
        XCTAssertEqual(
                LineMovement().calculateWholeLineTailMovement(input: try readLines()), 2_504
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day09.txt")
    }
}