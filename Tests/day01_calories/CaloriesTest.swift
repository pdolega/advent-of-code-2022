import XCTest

@testable import Source

final class CaloriesTest: XCTestCase {
    func testExample() throws {


        let readData = try TestUtil.readInput(fileName: "day01-1.txt")
        print(readData)


        XCTAssertEqual(CaloriesCounting().countCalories(), "dupa")
    }
}

