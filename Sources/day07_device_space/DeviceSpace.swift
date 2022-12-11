import Foundation

class DeviceSpace {

    class Dir {
        var name: String
        var size: Int {
            didSet {
                if let parent {
                    let diff = size - oldValue
                    parent.size += diff
                }
            }
        }
        var parent: Dir?

        var contents: [Dir] = []

        init(name: String, size: Int, parent: Dir?) {
            self.name = name
            self.size = size
            self.parent = parent
        }
    }

    struct File {
        var name: String
        var size: Int
    }

    struct CdCommand: Equatable {
        var target: String
    }

    func sumDirSizes(input: [String]) -> Int {
        let dirs = buildDirList(input: input)
        let sizeSum = dirs.filter {
            $0.size < 100000
        }.reduce(0) { (sum: Int, dir: Dir) in
            sum + dir.size
        }

        return sizeSum
    }

    func calculateDirSizeToDelete(input: [String]) -> Int {

        let dirs = buildDirList(input: input)

        let root = dirs.first!
        let spaceLeft = 70000000 - root.size
        let spaceNeeded = 30000000 - spaceLeft

        let sortedDirs = dirs
                .filter { $0.size > spaceNeeded }
                .sorted { (left: Dir, right: Dir) in  left.size < right.size}

        return sortedDirs.first!.size
    }

    private func buildDirList(input: [String]) -> [Dir] {
        let root = Dir(name: "/", size: 0, parent: nil)
        var currentNode = root

        input.forEach { line in
            if line.first! == Character("$") {
                // only care about CD command
                if let cdCommand = parseCd(line: line) {
                    currentNode = executeCd(command: cdCommand, root: root, currentNode: currentNode)
                }
            } else {    // ls output
                if let file = parseFileOutput(line: line) {
                    currentNode.size += file.size
                }
            }
        }

        return flattenTreeToList(dir: root)
    }

    private func parseCd(line: String) -> CdCommand? {
        if let captures = Util.firstRegexMatch(string: line, pattern: #"\$ cd (.+)"#) {
            let target = captures[1]
            return CdCommand(target: String(target))
        } else {
            return nil
        }
    }

    private func parseFileOutput(line: String) -> File? {
        if let captures = Util.firstRegexMatch(string: line, pattern: #"(\d+) (.+)"#) {
            let size = captures[1]
            let name = captures[2]
            return File(name: String(name), size: Int(size)!)
        } else {
            return nil
        }
    }

    private func executeCd(command: CdCommand, root: Dir, currentNode: Dir) -> Dir {
        switch command {
            case CdCommand(target: "/"):
                return root

            case CdCommand(target: ".."):
                return currentNode.parent!

            default:
                let cdDirName = command.target
                let newDir = currentNode.contents.first { $0.name == cdDirName }

                if let newDir {
                    return newDir
                } else {
                    let dir = Dir(name: String(cdDirName), size: 0, parent: currentNode)
                    currentNode.contents.append(dir)
                    return dir
                }
        }
    }

    private func flattenTreeToList(dir: Dir, dirList: [Dir] = []) -> [Dir] {
        var dirs = dirList

        dirs.append(dir)

        dir.contents.forEach { child in
            dirs.append(contentsOf: flattenTreeToList(dir: child, dirList: dirList))
        }

        return dirs
    }
}