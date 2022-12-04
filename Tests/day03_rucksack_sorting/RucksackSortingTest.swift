import Foundation
import XCTest

@testable import Source

final class RucksackSortingTest: XCTestCase {

    // 1st part
    func testSimpleMisplacedItems() throws {
        XCTAssertEqual(
                RucksackSorting().countMisplacedItems(
                        items: [
                            "vJrwpWtwJgWrhcsFMMfFFhFp",
                            "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
                            "PmmdzqPrVvPwwTWBwg",
                            "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
                            "ttgJtRGJQctTZtZT",
                            "CrZsJsPPZsGzwwsLwLmpwMDw",
                        ]
                ),
                157
        )
    }

    func testRealInputCompartments() throws {
        XCTAssertEqual(
                RucksackSorting().countMisplacedItems(
                        items: try readLines()
                ),
                7_674
        )
    }

    // 2nd part
    func testSimpleIdentityBadges() throws {
        XCTAssertEqual(
                RucksackSorting().countBadgePriorities(
                        items: [
                            "vJrwpWtwJgWrhcsFMMfFFhFp",
                            "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
                            "PmmdzqPrVvPwwTWBwg",
                            "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
                            "ttgJtRGJQctTZtZT",
                            "CrZsJsPPZsGzwwsLwLmpwMDw",
                        ]
                ),
                70
        )
    }

    func testRealInputBadges() throws {
        XCTAssertEqual(
                RucksackSorting().countBadgePriorities(
                        items: try readLines()
                ),
                2_805
        )
    }

    private func readLines() throws -> [String] {
        return try TestUtil.readInputLines(fileName: "day03.txt")
    }
}

