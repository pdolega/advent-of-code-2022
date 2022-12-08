import Foundation

class TreeHouse {
    func countTreesVisibleFromOutside(input: [String]) -> Int {
        let map = toMatrix(input: input)

        var count = 0
        for row in 0..<map.count {
            for col in 0..<map[row].count {
                if isVisibleFromEdges(row: row, col: col, map: map) {
                    count += 1
                }
            }
        }

        return count
    }

    func maxScenicScore(input: [String]) -> Int {
        let map = toMatrix(input: input)

        var maxScore = 0
        for row in 0..<map.count {
            for col in 0..<map[row].count {
                let score = countScore(row: row, col: col, map: map)
                if score > maxScore {
                    maxScore = score
                }
            }
        }

        return maxScore
    }

    private func toMatrix(input: [String]) -> [[Int]] {
        input.map { line in
            line.map { Int(String($0))! }
        }
    }

    private func isVisibleFromEdges(row: Int, col: Int, map: [[Int]]) -> Bool {
        let tree = map[row][col]

        let visibleRight = isTreeVisible(tree: tree, treesToEdge: map[row][(col+1)...])
        let visibleLeft = isTreeVisible(tree: tree, treesToEdge: map[row][..<col].reversed())
        let visibleTop = isTreeVisible(tree: tree, treesToEdge: map[0..<row].map { $0[col] }.reversed())
        let visibleBottom = isTreeVisible(tree: tree, treesToEdge: map[(row+1)...].map { $0[col] })

        return visibleRight || visibleLeft || visibleTop || visibleBottom
    }

    private func isTreeVisible(tree: Int, treesToEdge: any Sequence<Int>) -> Bool {
        let highestTree = treesToEdge.max()
        return highestTree == nil || highestTree! < tree
    }

    private func countScore(row: Int, col: Int, map: [[Int]]) -> Int {
        let treeHouse = map[row][col]

        let rightCount = countVisibleTrees(
                treeHouseHeight: treeHouse,
                trees: map[row][(col+1)...]
        )

        let leftCount = countVisibleTrees(
                treeHouseHeight: treeHouse,
                trees: map[row][..<col].reversed()
        )

        let upCount = countVisibleTrees(
                treeHouseHeight: treeHouse,
                trees: map[0..<row].map { $0[col] }.reversed()
        )

        let downCount = countVisibleTrees(
                treeHouseHeight: treeHouse,
                trees: map[(row+1)...].map { $0[col] }
        )

        return rightCount * leftCount * upCount * downCount
    }

    private func countVisibleTrees(treeHouseHeight: Int, trees: any Sequence<Int>) -> Int {
        var count = 0

        _ = trees.first { candidate in
            count += 1
            return candidate >= treeHouseHeight
        }

        return count
    }
}