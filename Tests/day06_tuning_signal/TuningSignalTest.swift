import Foundation

import Foundation
import XCTest

@testable import Source

final class TuningSignalTest: XCTestCase {

    // 1st part
    func testSimpleSequences() throws {
        XCTAssertEqual(
                TuningSignal().findStartOfPacket(input: "bvwbjplbgvbhsrlpgdmjqwftvncz"),  5
        )

        XCTAssertEqual(
                TuningSignal().findStartOfPacket(input: "nppdvjthqldpwncqszvftbrmjlhg"),  6
        )

        XCTAssertEqual(
                TuningSignal().findStartOfPacket(input: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"),  10
        )

        XCTAssertEqual(
                TuningSignal().findStartOfPacket(input: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"),  11
        )
    }

    func testRealInputStartMarker() throws {
        XCTAssertEqual(
                TuningSignal().findStartOfPacket(
                        input: try String(readLines().first!)
                ),
                1_238
        )
    }

    // 2nd part
    func testRealInputStartMessage() throws {
        XCTAssertEqual(
                TuningSignal().findStartOfMessage(input: try String(readLines().first!)),
                4_095
        )
    }

    private func readLines() throws -> [String] {
        return try TestUtil.readInputLines(fileName: "day06.txt")
    }
}

