import Foundation

class TuningSignal {
    private enum StartOfSignal: Int {
        case startOfPacket = 4
        case startOfMessage = 16
    }

    func findStartOfPacket(input: String) -> Int {
        findStartOf(input: input, start: StartOfSignal.startOfPacket)
    }

    func findStartOfMessage(input: String) -> Int {
        findStartOf(input: input, start: StartOfSignal.startOfMessage)
    }

    private func findStartOf(input: String, start: StartOfSignal) -> Int {
        var buffer: [Character] = []
        var position = 0

        _ = input.first { char in
            position += 1

            let indexToDrop = buffer.firstIndex { v in v == char  }
            if let indexToDrop {
                buffer = Array(buffer.suffix(from: indexToDrop + 1))
            }
            buffer.append(char)

            return buffer.count == start.rawValue
        }

        return position
    }
}