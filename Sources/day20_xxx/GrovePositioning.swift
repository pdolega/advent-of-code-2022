import Foundation

class GrovePositioning {

    func mixOnce(input: [String]) -> Int {
        var parsedNumbers: [Int] = []
        input.forEach { line in
            parsedNumbers.append(Int(line)!)
        }

        let rearranged = rearrange(numbers: parsedNumbers)

        let index0 = rearranged.firstIndex(of: 0)!
        let numbers: [Int] = [1000, 2000, 3000]
                .map { ($0 + index0) % rearranged.count }
                .map { rearranged[$0] }


        return numbers.reduce(0, +)
    }

    func mix10Times(input: [String]) -> Int {
        var parsedNumbers: [Int] = []
        input.forEach { line in
            parsedNumbers.append(Int(line)!)
        }

        parsedNumbers = parsedNumbers.map { $0 * 811589153 }

        let rearranged = rearrange(numbers: parsedNumbers, times: 10)

        let index0 = rearranged.firstIndex(of: 0)!
        let numbers: [Int] = [1000, 2000, 3000]
                .map { ($0 + index0) % rearranged.count }
                .map { rearranged[$0] }

        return numbers.reduce(0, +)
    }

    func rearrange(numbers: [Int], times: Int = 1) -> [Int]  {
        var rearranged = numbers
        var indexMapping = Dictionary(
            uniqueKeysWithValues: numbers.enumerated().map { idx, _ in (idx , idx) }
        )

        var indexArr = numbers.enumerated().map { idx, _ in idx }

        for i in 0..<times {
            var calcTargetTime: UInt64 = 0
            var rewriteIdxTime: UInt64 = 0

            Util.timingMsg(description: "Iteration \(i)") {
                numbers.enumerated().forEach { idx, move in
                    let newInitialIdx = indexMapping[idx]!


                    let (newTargetIdx, calcTargetDiff) = Util.timed { calculateTargetIdx(move: move, initialIdx: newInitialIdx, numbers: rearranged) }
                    calcTargetTime += calcTargetDiff

                    // nothing changes
                    if newInitialIdx == newTargetIdx {
                        return
                    }

                    let (_, rewriteDiff) = Util.timed { rewriteIndices(indexMapping: &indexMapping, newInitialIdx: newInitialIdx, newTargetIdx: newTargetIdx, indexArr: &indexArr) }
                    rewriteIdxTime += rewriteDiff

                    rearranged.remove(at: newInitialIdx)
                    rearranged.insert(move, at: newTargetIdx)

//                print("After moving: \(numbers[idx]) -> \(rearranged)")
                }
            }

            print("Calculating target took: \(calcTargetTime/1_000_000)ms, Rewriting indices took: \(rewriteIdxTime/1_000_000)ms")
        }

        return rearranged
    }

    private func rewriteIndices(indexMapping: inout [Int: Int], newInitialIdx: Int, newTargetIdx: Int, indexArr: inout [Int]) {
        var rangeToRewrite: ClosedRange<Int>
        var shift = 0
        if newInitialIdx < newTargetIdx {
            rangeToRewrite = (newInitialIdx + 1)...newTargetIdx
            shift = -1
        } else {
            rangeToRewrite = newTargetIdx...(newInitialIdx - 1)
            shift = 1
        }

        indexMapping.forEach { key, value in
            if value == newInitialIdx {
                indexMapping[key] = newTargetIdx
            } else if rangeToRewrite.contains(value) {
                indexMapping[key] = value + shift
            }
        }
    }

    private func calculateTargetIdx(move: Int, initialIdx: Int, numbers: [Int]) -> Int {
        let boundedDistance = move % (numbers.count - 1)

        var newTargetIdx = initialIdx + boundedDistance
        if newTargetIdx >= numbers.count {
            newTargetIdx = (newTargetIdx - numbers.count) + 1
        } else if newTargetIdx < 0 {
            newTargetIdx = numbers.count - 1 + newTargetIdx
        }

        return newTargetIdx
    }
}