import Foundation

import Foundation
import XCTest

@testable import Source

final class MonkeyMathTest: XCTestCase {

    private let testData = """
                           root: pppw + sjmn
                           dbpl: 5
                           cczh: sllz + lgvd
                           zczc: 2
                           ptdq: humn - dvpt
                           dvpt: 3
                           lfqf: 4
                           humn: 5
                           ljgn: 2
                           sjmn: drzm * dbpl
                           sllz: 4
                           pppw: cczh / lfqf
                           lgvd: ljgn * ptdq
                           drzm: hmdt - zczc
                           hmdt: 32
                           """

    //  1st part
    func testSimpleMixOnce() throws {
        XCTAssertEqual(
            MonkeyMath().calculateAllKnown(input: testData.components(separatedBy: "\n")), 152
        )
    }

    func testRealInputMixOnce() throws {
        XCTAssertEqual(
            MonkeyMath().calculateAllKnown(input: try readLines()),  87457751482938 // too low
        )
    }

    // 2nd part
    func testSimpleMix10Times() throws {
        XCTAssertEqual(
            MonkeyMath().calculateHumnUknown(input: testData.components(separatedBy: "\n")),  301
        )
    }

    func testRealInputMix10Times() throws {
        XCTAssertEqual(
            MonkeyMath().calculateHumnUknown(input: try readLines()),  3221245824363
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day21.txt")
    }
}