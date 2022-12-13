import Foundation

protocol Item {}
extension Int: Item {}
extension Array<Item>: Item {}


class ItemComparator {
    static func compare(lhs: Item, rhs: Item) -> Int {
        switch (lhs, rhs) {
            case (let int1 as Int, let int2 as Int):
                return int1 - int2

            case (let int1 as Int, let arr2 as [Item]):
                return compare(lhs: [int1], rhs: arr2)

            case (let arr1 as [Item], let int2 as Int):
                return compare(lhs: arr1, rhs: [int2])

            case (let arr1 as [Item], let arr2 as [Item]):
                var defaultReturn = 0
                if arr1.count < arr2.count {
                    defaultReturn = -1
                } else if arr1.count > arr2.count {
                    defaultReturn = 1
                }

                let minLength = min(arr1.count, arr2.count)

                for i in 0..<minLength {
                    let partialComparison = compare(lhs: arr1[i], rhs: arr2[i])
                    if partialComparison != 0 {
                        return partialComparison
                    }
                }

                return defaultReturn

            default:
                assertionFailure("Element must contain either array or single num")
                return 0
        }
    }
}

class DistressSignal {
    func countCorrectOrder(input: [String]) -> Int {
        var pairIndex = 1
        var values: [Item] = []
        var correctPairs: [Int] = []

        input.forEach { line in
            if line == "" {
                assert(values.count == 2, "Incorrect number of values: \(values.count)")

                let isSorted = ItemComparator.compare(lhs: values.first!, rhs: values.last!)
                if(isSorted < 0) {
                    correctPairs.append(pairIndex)
                }
                pairIndex += 1

                values.removeAll()
            } else {
                values.append(parseValue(line: line))
            }
        }

        return correctPairs.reduce(0, +)
    }

    func calculateDividerInsertion(input: [String]) -> Int {
        var values: [Item] = []

        input.forEach { line in
            if line != "" {
                values.append(parseValue(line: line))
            }
        }

        let (div1, div2) = ([[2]], [[6]]) as (Item, Item)

        values.append(contentsOf: [div1, div2])
        values.sort { ItemComparator.compare(lhs: $0, rhs: $1) < 0  }

        var indices: [Int] = []
        for (idx, value) in values.enumerated() {
            if(ItemComparator.compare(lhs: value, rhs: div1) == 0 || ItemComparator.compare(lhs: value, rhs: div2) == 0) {
                indices.append(idx + 1)
            }
        }

        return indices.first! * indices.last!
    }

    private func parseValue(line: String) -> [Item] {
        let changedLine = line.map { char in
            switch char {
                case Character("["): return "[ "
                case Character("]"): return " ]"
                default: return String(char)
            }
        }.joined()

        let chunk = changedLine.split { c in [",", " "].contains { $0 == c } }.map { String($0) }

        var arrayStack: [[Item]] = []
        var lastItem: [Item]? = nil

        chunk.forEach { slice in
            if slice == "[" {
                arrayStack.append([])
            } else if slice == "]" {
                lastItem = arrayStack.removeLast()
                if !arrayStack.isEmpty {
                    appendToParent(stack: &arrayStack, newItem: lastItem!)
                }
            } else {
                appendToParent(stack: &arrayStack, newItem: Int(slice)!)
            }
        }

        return lastItem!
    }

    private func appendToParent(stack: inout [[Item]], newItem: Item) {
        var currentList = stack.removeLast()
        currentList.append(newItem)
        stack.append(currentList)
    }
}