import Foundation

import Foundation
import XCTest

@testable import Source

final class DeviceSpaceTest: XCTestCase {

    private let testInput = """
                            $ cd /
                            $ ls
                            dir a
                            14848514 b.txt
                            8504156 c.dat
                            dir d
                            $ cd a
                            $ ls
                            dir e
                            29116 f
                            2557 g
                            62596 h.lst
                            $ cd e
                            $ ls
                            584 i
                            $ cd ..
                            $ cd ..
                            $ cd d
                            $ ls
                            4060174 j
                            8033020 d.log
                            5626152 d.ext
                            7214296 k
                            """.components(separatedBy: "\n")

    // 1st part
    func testSimpleDirSum() throws {
        XCTAssertEqual(
                DeviceSpace().sumDirSizes(input: testInput),  95_437
        )
    }

    func testRealInputDirSum() throws {
        XCTAssertEqual(
            DeviceSpace().sumDirSizes(input: try readLines()), 1501149
        )
    }


    // 2nd part
    func testSimpleCalculateDirSize() throws {
        XCTAssertEqual(
                DeviceSpace().calculateDirSizeToDelete(input: testInput),  24933642
        )
    }

    func testRealInputCalculateDirSize() throws {
        XCTAssertEqual(
                DeviceSpace().calculateDirSizeToDelete(input: try readLines()), 10_096_985
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day07.txt")
    }
}

