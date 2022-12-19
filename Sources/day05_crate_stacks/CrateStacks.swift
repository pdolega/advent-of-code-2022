import Foundation

struct Movement: Equatable {
    let number: Int
    let from: Int
    let to: Int

    static func ==(lhs: Movement, rhs: Movement) -> Bool {
        lhs.number == rhs.number && lhs.from == rhs.from && lhs.from == rhs.from
    }
}

class CrateStacks {

    private enum CraneVersion {
        case CrateMover_9000
        case CrateMover_9001
    }

    func calculateRearrangement(inputLines: [String]) -> String {
        let input = InputParser().parseInput(input: inputLines)
//        printStack(stacks: input.0)

        return performRearrangements(positions: input.0, movements: input.1, craneModel: CraneVersion.CrateMover_9000)
    }

    func calculateRearrangement2ndCrane(inputLines: [String]) -> String {
        let input = InputParser().parseInput(input: inputLines)
//        printStack(stacks: input.0)

        return performRearrangements(positions: input.0, movements: input.1, craneModel: CraneVersion.CrateMover_9001)
    }

    private func performRearrangements(positions: [[String]], movements: [Movement], craneModel: CraneVersion) -> String {
        var stacks = positions

        movements.forEach { move in
            var stackFrom = stacks[move.from - 1]
            var stackTo = stacks[move.to - 1]

            let cratesToMove = stackFrom.prefix(move.number)
            stackFrom.removeFirst(move.number)
            stacks[move.from - 1] = stackFrom

            switch craneModel {
                case .CrateMover_9000:
                    stackTo.insert(contentsOf: cratesToMove.reversed(), at: 0)
                case .CrateMover_9001:
                    stackTo.insert(contentsOf: cratesToMove, at: 0)
            }

            stacks[move.to - 1] = stackTo

            // debugging
//            print("Movement: [move \(move.number) from \(move.from) to \(move.to)]")
//            printStack(stacks: stacks)
        }

        return stacks.map { $0.first! }.joined()
    }

    private func printStack(stacks: [[String]]) {
        for (index, stack) in stacks.enumerated() {
            print("\(index): \(stack) (\(stack.count))")
        }
    }
}

class InputParser {
    func parseInput(input: [String]) -> ([[String]], [Movement]) {
        let indexOfEndOfDescription = input.firstIndex(where:  { $0.isEmpty })!
        let stackDescription = input[..<(indexOfEndOfDescription)]
        let movementDescription = input[(indexOfEndOfDescription + 1)...]

        return (
                parseStacks(stackDescription: Array(stackDescription)),
                parseMoves(movementDescription: movementDescription)
        )
    }

    private func parseMoves(movementDescription: ArraySlice<String>) -> [Movement] {
        let pattern = #"move (\d+) from (\d+) to (\d+)"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let movements = movementDescription.map { line -> Movement? in
                    let range = NSRange(line.startIndex..<line.endIndex, in: line)
                    let matches = regex.matches(in: line, range: range)

                    if let match = matches.first {
                        let numberString = line[Range(match.range(at: 1), in: line)!]
                        let fromString = line[Range(match.range(at: 2), in: line)!]
                        let toString = line[Range(match.range(at: 3), in: line)!]

                        return Movement(number: Int(numberString)!, from: Int(fromString)!, to: Int(toString)!)
                    } else {
                        return nil
                    }
                }.filter { $0 != nil }.map { $0! }
        return movements
    }

    private func parseStacks(stackDescription: [String]) -> [[String]] {
        let charsPerStack = 4

        var stacks: [[String]] = []

        stackDescription[0..<stackDescription.count - 1].forEach { line in
            var stackNo = 0
            for windowStart in stride(from: 0, to: line.count, by: charsPerStack) {
                if stackNo >= stacks.count {
                    stacks.append([])
                }

                let start = line.index(line.startIndex, offsetBy: windowStart)
                let end = line.index(line.startIndex, offsetBy: windowStart + charsPerStack - 1)

                let stackSlice = line[start..<end].trimmingCharacters(in: .whitespaces)

                if !stackSlice.isEmpty {
                    let stackNameIdx = stackSlice.index(stackSlice.startIndex, offsetBy: 1)
                    stacks[stackNo].append(String(stackSlice[stackNameIdx]))
                }

                stackNo += 1
            }
        }

        return stacks
    }
}

