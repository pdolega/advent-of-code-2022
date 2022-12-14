import Foundation

class TestUtil {

    static func readInputLines(fileName: String) throws -> [String] {
        print("Current working path is: \(FileManager.default.currentDirectoryPath)")

        let path = FileManager.default.currentDirectoryPath
        let fileUrl = URL(fileURLWithPath: path).appendingPathComponent("InputFiles").appendingPathComponent(fileName)

        do {
            let text = try String(contentsOf: fileUrl, encoding: .utf8)
            print("Found file at \(fileUrl)...")
            return text.components(separatedBy: "\n")
        } catch {
            print("File not found at \(fileUrl)...")
            print(error)
            throw error
        }
    }
}
