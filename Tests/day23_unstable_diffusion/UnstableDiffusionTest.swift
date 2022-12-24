import Foundation

import Foundation
import XCTest

@testable import Source

final class UnstableDiffusionTest: XCTestCase {

    private let trivialSample = """
                                 .....
                                 ..##.
                                 ..#..
                                 .....
                                 ..##.
                                 .....
                                 """

    private let testData = """
                           ..............
                           ..............
                           .......#......
                           .....###.#....
                           ...#...#.#....
                           ....#...##....
                           ...#.###......
                           ...##.#.##....
                           ....#..#......
                           ..............
                           ..............
                           ..............
                           """

    //  1st part
    func testTrivialRoundLimit() throws {
        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: trivialSample.components(separatedBy: "\n"), roundLimit: 10)

        XCTAssertEqual(emptyFields, 5 * 6 - 5)
        XCTAssertEqual(round, 4)
    }

    func testSimpleRoundLimit() throws {
        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: testData.components(separatedBy: "\n"), roundLimit:  10)
        XCTAssertEqual(emptyFields, 110)
        XCTAssertEqual(round, 10)
    }

//    func testRealInputRoundLimit() throws {
//        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: try readLines(), roundLimit: 10)
//        XCTAssertEqual(emptyFields, 4116)
//        XCTAssertEqual(round, 10)
//    }

    //  2nd part
    func testTrivialToStable() throws {
        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: trivialSample.components(separatedBy: "\n"))

        XCTAssertEqual(emptyFields, 5 * 6 - 5)
        XCTAssertEqual(round, 4)
    }

    func testSimpleToStable() throws {
        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: testData.components(separatedBy: "\n"))
        XCTAssertEqual(emptyFields, 146)
        XCTAssertEqual(round, 20)
    }

//    func testRealInputToStable() throws {
//        let (emptyFields, round) = UnstableDiffusion().diffuseElves(input: try readLines())
//        XCTAssertEqual(emptyFields, 17247)
//        XCTAssertEqual(round, 984)
//    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day23.txt")
    }
}