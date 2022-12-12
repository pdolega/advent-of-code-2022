import Foundation

class Node: Equatable, Hashable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

class HillClimb {
    let baseHeight = Int(Character("a").asciiValue!)

    func findShortestPath(input: [String]) -> Int {
        let (map, startingPosition, targetPosition) = parseInput(input: input)
        return findShortestPath(startNode: startingPosition, targetNode: targetPosition, map: map)!
    }

    func findShortestFromAllPaths(input: [String]) -> Int {
        let (map, _, targetPosition) = parseInput(input: input)
        let startPoints = map.filter { (key: Node, value: Int) in value == 0 }.keys

        let minShortestPath = startPoints.map { startNode in
            findShortestPath(startNode: startNode, targetNode: targetPosition, map: map)
        }.filter { $0 != nil  }
         .map { $0! }
         .min { $0 < $1 }!

        return minShortestPath
    }

    private func findShortestPath(startNode: Node, targetNode: Node, map: [Node: Int]) -> Int? {
        var visited: Set<Node> = Set([startNode])
        var previousTrail: [Node:Node] = [startNode: Node(x: -1, y: -1)]
        var queue: [Node] = [startNode]

        while !queue.isEmpty {
            let node = queue.removeFirst()
            let candidates = getPossibleMoves(currentPosition: node, visited: visited, map: map)

            for candidate in candidates {
                visited.insert(candidate)
                previousTrail[candidate] = node
                queue.append(candidate)

                if candidate == targetNode {
                    return countPathLength(targetNode: targetNode, previousTrail: previousTrail)
                }
            }
        }

        return nil
    }

    private func countPathLength(targetNode: Node, previousTrail: [Node: Node]) -> Int {
        var crawl = targetNode
        var path: [Node] = [crawl]

        var count = 0
        while previousTrail[crawl] != Node(x: -1, y: -1) {
            crawl = previousTrail[crawl]!
            path.append(crawl)
            count += 1
        }
        return count
    }

    private func getPossibleMoves(currentPosition: Node, visited: Set<Node>, map: [Node: Int]) -> [Node] {
        let options: [Node] = [
            Node(x: currentPosition.x - 1, y: currentPosition.y), // left
            Node(x: currentPosition.x + 1, y: currentPosition.y), // right
            Node(x: currentPosition.x, y: currentPosition.y - 1), // up
            Node(x: currentPosition.x, y: currentPosition.y + 1), // down
        ]

        return options
                    .filter { map[$0] != nil }
                    .filter { option in
                        let targetHeight = map[option]!
                        let currentHeight = map[currentPosition]!
                        return targetHeight <= currentHeight + 1  && !visited.contains(option)
                    }
    }

    private func parseInput(input: [String]) -> ([Node: Int], Node, Node) {
        var map: [Node: Int] = [:]
        var startingPosition: Node? = nil
        var targetPosition: Node? = nil

        for row in 0..<input.count {
            var col = 0
            input[row].forEach { char in
                var height = -1
                if char == Character("S") {
                    startingPosition = Node(x: col, y: row)
                    height = Int(Character("a").asciiValue!) - baseHeight
                } else if char == Character("E") {
                    targetPosition = Node(x: col, y: row)
                    height =  Int(Character("z").asciiValue!) - baseHeight
                } else {
                    height =  Int(char.asciiValue!) - baseHeight
                }
                map[Node(x: col, y: row)] = height
                col += 1
            }
        }

        return (map, startingPosition!, targetPosition!)
    }
}