import Foundation

import Foundation
import XCTest

@testable import Source

final class BeaconExclusionZoneTest: XCTestCase {

    private let testData = """
                           Sensor at x=2, y=18: closest beacon is at x=-2, y=15
                           Sensor at x=9, y=16: closest beacon is at x=10, y=16
                           Sensor at x=13, y=2: closest beacon is at x=15, y=3
                           Sensor at x=12, y=14: closest beacon is at x=10, y=16
                           Sensor at x=10, y=20: closest beacon is at x=10, y=16
                           Sensor at x=14, y=17: closest beacon is at x=10, y=16
                           Sensor at x=8, y=7: closest beacon is at x=2, y=10
                           Sensor at x=2, y=0: closest beacon is at x=2, y=10
                           Sensor at x=0, y=11: closest beacon is at x=2, y=10
                           Sensor at x=20, y=14: closest beacon is at x=25, y=17
                           Sensor at x=17, y=20: closest beacon is at x=21, y=22
                           Sensor at x=16, y=7: closest beacon is at x=15, y=3
                           Sensor at x=14, y=3: closest beacon is at x=15, y=3
                           Sensor at x=20, y=1: closest beacon is at x=15, y=3
                           """

    // 1st part
    func testSimpleCoverageAtRow() throws {
        XCTAssertEqual(
                BeaconExclusionZone().countCoverageAtRow(input: testData.components(separatedBy: "\n"), y: 10),  26
        )
    }

    func testRealInputCoverageAtRow() throws {
        XCTAssertEqual(
                BeaconExclusionZone().countCoverageAtRow(input: try readLines(), y: 2_000_000), 5_508_234
        )
    }

    // 2nd part
    func testSimpleAllPaths() throws {
        XCTAssertEqual(
                BeaconExclusionZone().calculateTuningFrequency(input: testData.components(separatedBy: "\n"), mapRange: 0...20),  56000011
        )
    }

    func testRealInputAllPaths() throws {
        XCTAssertEqual(
                BeaconExclusionZone().calculateTuningFrequency(input: try readLines(), mapRange: 0...4000000), 10_457_634_860_779
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day15.txt")
    }
}