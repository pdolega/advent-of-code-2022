import XCTest

@testable import Source

final class CaloriesTest: XCTestCase {

    // 1st part
    func testEmpty() throws {
        XCTAssertEqual(
                CaloriesCounting().countCalories(calories: []),
                0
        )
    }

    func testSimple() throws {
        XCTAssertEqual(
                CaloriesCounting().countCalories(
                        calories: [3_000, 4_000, 5_000, nil, 2_000, 1_000]
                ),
                12_000
        )
    }

    func testTopRealInput() throws {
        let maybeCalories = try toIntLines()

        XCTAssertEqual(
                CaloriesCounting().countCalories(calories: maybeCalories),
                66_487
        )
    }

    func testTop3Simple() throws {
        XCTAssertEqual(
                CaloriesCounting().countTop3Total(
                        calories: [3_000, 4_000, nil, 2_000, 1_000, nil, 10, 100, 0, nil, 1, 2]
                ),
                7_000 + 3_000 + 110
        )
    }

    // 2nd part
    func testTop3RealInput() throws {
        let maybeCalories = try toIntLines()

        XCTAssertEqual(
                CaloriesCounting().countTop3Total(calories: maybeCalories),
                197_301
        )
    }

    private func toIntLines() throws -> [Int?] {
        let readLines = try TestUtil.readInputLines(fileName: "day01-1.txt")
        return readLines.map({ line in
            line.isEmpty ? nil : Int(line)
        })
    }
}

