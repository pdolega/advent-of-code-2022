import Foundation

class CathodeRayDisplay {

    func addRegisterCycles(input: [String]) -> Int {
        let valuesInCycles = getRegisterCycleValues(input: input)
        let cyclesToCheck = [20, 60, 100, 140, 180, 220]

        return cyclesToCheck.map { cycle in
            cycle * valuesInCycles[cycle]!
        }.reduce(0, +)
    }

    func drawDisplay(input: [String]) -> String {
        var display: [[String]] = Array.init(repeating: [], count: 6)
        for i in 0..<display.count {
            display[i] = Array.init(repeating: ".", count: 40)
        }

        let registerCycleValues = getRegisterCycleValues(input: input)

        registerCycleValues.forEach { cycle, spriteCenter in
            let displayLine = (cycle - 1) / 40
            let pixelPosition = (cycle - 1) % 40

            if pixelPosition >= spriteCenter - 1 && pixelPosition <= spriteCenter + 1 {
                display[displayLine][pixelPosition] = "#"
            }
        }

        return display.map { line in
                    line.joined()
                }.joined(separator: "\n")
    }

    private func getRegisterCycleValues(input: [String]) -> [Int: Int] {
        var cycle = 1
        var currentRegisterVal = 1
        var valuesInCycles: [Int: Int] = [:]

        input.forEach { line in
            let parsedLine = line.components(separatedBy: " ")
            valuesInCycles[cycle] = currentRegisterVal

            if parsedLine.first == "noop" {
                cycle += 1
            } else {
                cycle += 1
                valuesInCycles[cycle] = currentRegisterVal

                cycle += 1
                let valToAdd = Int(parsedLine.last!)!
                currentRegisterVal += valToAdd
            }
        }

        return valuesInCycles
    }
}