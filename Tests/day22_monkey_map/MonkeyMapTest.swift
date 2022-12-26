import Foundation

import Foundation
import XCTest

@testable import Source

final class MonkeyMapTest: XCTestCase {

    private let testData = """
                                   ...#
                                   .#..
                                   #...
                                   ....
                           ...#.......#
                           ........#...
                           ..#....#....
                           ..........#.
                                   ...#....
                                   .....#..
                                   .#......
                                   ......#.

                           10R5L5R10L4R5L5
                           """

    //  1st part
    func testSimplePlane() throws {
        XCTAssertEqual(
            MonkeyMap().calculatePlanePath(input: testData.components(separatedBy: "\n")), 6_032
        )
    }

    func testRealInputPlane() throws {
        XCTAssertEqual(
            MonkeyMap().calculatePlanePath(input: try readLines()),  55_244
        )
    }

    // 2nd part
    func testSimpleCube() throws {
        let frontSide = CubeSide(name: "face" , x: 2, y: 0, sideSize: 4)
        let rearSide = CubeSide(name: "rear" , x: 2, y: 2, sideSize: 4)

        let topSide = CubeSide(name: "top" , x: 0, y: 1, sideSize: 4)
        let bottomSide = CubeSide(name: "bottom" , x: 2, y: 1, sideSize: 4)

        let rightSide = CubeSide(name: "right" , x: 3, y: 2, sideSize: 4)
        let leftSide = CubeSide(name: "left" , x: 1, y: 1, sideSize: 4)

        let cubeFaces = CubeLayout(
                front: CubeSideConfig.edgeConfig(
                        side: frontSide,
                        configMap: [ .Up: (topSide, 180), .Down: (bottomSide, 0), .Left: (leftSide, 90), .Right: (rightSide, 180) ]
                ),
                rear: CubeSideConfig.edgeConfig(
                        side: rearSide,
                        configMap: [ .Up: (bottomSide, 0), .Down: (topSide, 180), .Left: (leftSide, 270), .Right: (rightSide, 0) ]
                ),
                top: CubeSideConfig.edgeConfig(
                        side: topSide,
                        configMap: [ .Up: (frontSide, 180), .Down: (rearSide, 180),  .Left: (rightSide, 270), .Right: (leftSide, 0) ]
                ),
                bottom: CubeSideConfig.edgeConfig(
                        side: bottomSide,
                        configMap: [ .Up: (frontSide, 0), .Down: (rearSide, 0),  .Left: (leftSide, 0), .Right: (rightSide, 270) ]
                ),
                left: CubeSideConfig.edgeConfig(
                        side: leftSide,
                        configMap: [ .Up: (frontSide, 270), .Down: (rearSide, 90),  .Left: (topSide, 0), .Right: (bottomSide, 0) ]
                ),
                right: CubeSideConfig.edgeConfig(
                        side: rightSide,
                        configMap: [ .Up: (bottomSide, 90), .Down: (topSide, 90),  .Left: (rearSide, 0), .Right: (frontSide, 180) ]
                )
        )

        XCTAssertEqual(
            MonkeyMap().calculateCubePath(input: testData.components(separatedBy: "\n"), cube: cubeFaces),  5_031
        )
    }

    func testRealInputCube() throws {
        let frontSide = CubeSide(name: "face" , x: 1, y: 0, sideSize: 50)
        let rightSide = CubeSide(name: "right" , x: 2, y: 0, sideSize: 50)

        let leftSide = CubeSide(name: "left" , x: 0, y: 2, sideSize: 50)
        let rearSide = CubeSide(name: "rear" , x: 1, y: 2, sideSize: 50)

        let topSide = CubeSide(name: "top" , x: 0, y: 3, sideSize: 50)
        let bottomSide = CubeSide(name: "bottom" , x: 1, y: 1, sideSize: 50)


        let cubeFaces = CubeLayout(
                front: CubeSideConfig.edgeConfig(
                        side: frontSide,
                        configMap: [ .Up: (topSide, 270), .Down: (bottomSide, 0), .Left: (leftSide, 180), .Right: (rightSide, 0) ]
                ),
                rear: CubeSideConfig.edgeConfig(
                        side: rearSide,
                        configMap: [ .Up: (bottomSide, 0), .Down: (topSide, 270), .Left: (leftSide, 0), .Right: (rightSide, 180) ]
                ),
                top: CubeSideConfig.edgeConfig(
                        side: topSide,
                        configMap: [ .Up: (leftSide, 0), .Down: (rightSide, 0),  .Left: (frontSide, 90), .Right: (rearSide, 90) ]
                ),
                bottom: CubeSideConfig.edgeConfig(
                        side: bottomSide,
                        configMap: [ .Up: (frontSide, 0), .Down: (rearSide, 0),  .Left: (leftSide, 90), .Right: (rightSide, 90) ]
                ),
                left: CubeSideConfig.edgeConfig(
                        side: leftSide,
                        configMap: [ .Up: (bottomSide, 270), .Down: (topSide, 0),  .Left: (frontSide, 180), .Right: (rearSide, 0) ]
                ),
                right: CubeSideConfig.edgeConfig(
                        side: rightSide,
                        configMap: [ .Up: (topSide, 0), .Down: (bottomSide, 270),  .Left: (frontSide, 0), .Right: (rearSide, 180) ]
                )
        )

        XCTAssertEqual(
            MonkeyMap().calculateCubePath(input: try readLines(), cube: cubeFaces),  123_149
        )
    }

    private func readLines() throws -> [String] {
        try TestUtil.readInputLines(fileName: "day22.txt")
    }
}