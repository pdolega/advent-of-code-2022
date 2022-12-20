import Foundation

import Foundation
import XCTest

@testable import Source

final class GrovePositioningTest: XCTestCase {

    private let testData = """
                           1
                           2
                           -3
                           3
                           -2
                           0
                           4
                           """

//     1st part
    func testSimpleMixOnce() throws {
        XCTAssertEqual(
            GrovePositioning().mixOnce(input: testData.components(separatedBy: "\n")), 3
        )
    }

    func testRealInputMixOnce() throws {
        XCTAssertEqual(
                GrovePositioning().mixOnce(input: try readLines()),  7395 // too low
        )
    }

//    // 2nd part
    func testSimpleMix10Times() throws {
        XCTAssertEqual(
                GrovePositioning().mix10Times(input: testData.components(separatedBy: "\n")),  1623178306
        )
    }

    func testRealInputMix10Times() throws {
        XCTAssertEqual(
                GrovePositioning().mix10Times(input: try readLines()),  1640221678213
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day20.txt")
    }
}