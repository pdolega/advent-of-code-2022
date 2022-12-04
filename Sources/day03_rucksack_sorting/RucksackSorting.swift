import Foundation

class RucksackSorting {
    let AsciiStart = Int(Character("a").asciiValue!)

    let LowerOffset = 1
    let UpperOffset = 27

    func countMisplacedItems(items: [String]) -> Int {
        var prioritySum = 0

        items.forEach { (content: String) in
            let halfSize = content.count/2
            let (firstComp, secondComp) = (content.prefix(halfSize), content.suffix(halfSize))

            let intersection = Set(firstComp).intersection(secondComp)
            assert(intersection.count == 1, "There should be only 1 repeated element")

            if let letter = intersection.first {
                prioritySum += priority(letter: letter)
            }
        }

        return prioritySum
    }

    func countBadgePriorities(items: [String]) -> Int {
        var prioritySum = 0
        let triples = convertToTriples(items: items)

        triples.forEach { triple in
            let badge = triple.reduce(Set(triple.first!)) { intersection, element in
                intersection.intersection(element)
            }
            assert(badge.count == 1, "Only 1 common element should have been found")
            prioritySum += priority(letter: badge.first!)
        }

        return prioritySum
    }

    private func convertToTriples(items: [String]) -> [[String]] {
        var triples: [[String]] = []
        items.reduce([]) { (triple: [String], elem: String) in
            let triple = triple.count < 3 ? triple + [elem] : [elem]

            if triple.count == 3 {
                triples.append(triple)
            }

            return triple
        }
        return triples
    }

    private func priority(letter: Character) -> Int {
        let ascii = Int(letter.lowercased().first!.asciiValue!) - AsciiStart
        return letter.isLowercase ? ascii + LowerOffset : ascii + UpperOffset
    }
}
