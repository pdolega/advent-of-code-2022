import Foundation

import Foundation
import XCTest

@testable import Source

final class HotAirBalloonsTest: XCTestCase {

    private let testData = """
                           1=-0-2
                           12111
                           2=0=
                           21
                           2=01
                           111
                           20012
                           112
                           1=-1=
                           1-12
                           12
                           1=
                           122
                           """

    //  1st part
    func testSimpleSum() throws {
        XCTAssertEqual(
            HotAirBalloons().sumAllNumbers(input: testData.components(separatedBy: "\n")), "2=-1=0"
        )
    }

    func testRealInputSum() throws {
        XCTAssertEqual(
            HotAirBalloons().sumAllNumbers(input: try readLines()),  "20=2-02-0---02=22=21"
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day25.txt")
    }
}