import Foundation

import Foundation
import XCTest

@testable import Source

final class CreateStacksTest: XCTestCase {

    private let testData = """
                               [D]     
                           [N] [C]     
                           [Z] [M] [P] 
                            1   2   3

                           move 1 from 2 to 1
                           move 3 from 1 to 3
                           move 2 from 2 to 1
                           move 1 from 1 to 2
                           """

    func testInputParsing() throws {
        let (stacks, movements) = InputParser().parseInput(
                input: testData.components(separatedBy: "\n")
        )

        XCTAssertEqual(
                stacks,
                [
                    ["N", "Z"],
                    ["D", "C", "M"],
                    ["P"],
                ],
                "Initial stack layout parsed incorrectly"
        )

        XCTAssertEqual(
                movements,
                [
                    Movement(number: 1, from: 2, to: 1),
                    Movement(number: 3, from: 1, to: 3),
                    Movement(number: 2, from: 2, to: 1),
                    Movement(number: 1, from: 1, to: 2)
                ],
                "Movements parsed incorrectly"
        )
    }

    // 1st part
    func testSimpleArrangements() throws {
        XCTAssertEqual(
                CrateStacks().calculateRearrangement(inputLines: testData.components(separatedBy: "\n")),
                "CMZ"
        )
    }

    func testRealInputCrateArrangement() throws {
        XCTAssertEqual(
                CrateStacks().calculateRearrangement(inputLines: try readLines()),
                "VJSFHWGFT"
        )
    }

    // 2nd part
    func testSimpleArrangements2ndCrane() throws {
        XCTAssertEqual(
                CrateStacks().calculateRearrangement2ndCrane(inputLines: testData.components(separatedBy: "\n")),
                "MCD"
        )
    }

    func testRealInputCrateArrangement2ndCrate() throws {
        XCTAssertEqual(
                CrateStacks().calculateRearrangement2ndCrane(inputLines: try readLines()),
                "LCTQFBVZV"
        )
    }

    private func readLines() throws -> [String] {
        return try TestUtil.readInputLines(fileName: "day05.txt")
    }
}

