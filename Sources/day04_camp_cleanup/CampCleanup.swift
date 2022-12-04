import Foundation

class CampCleanup {
    func countCompleteOverlap(assignments: [(String, String)]) -> Int {
        var overlapCount = 0

        assignments.forEach { (assignment1st, assignment2nd) in
            let set1 = assignmentToSet(assignment: assignment1st)
            let set2 = assignmentToSet(assignment: assignment2nd)

            if set1.isSuperset(of: set2) || set2.isSuperset(of: set1) {
                overlapCount += 1
            }
        }

        return overlapCount
    }

    func countPartialOverlap(assignments: [(String, String)]) -> Int {
        var overlapCount = 0

        assignments.forEach { (assignment1st, assignment2nd) in
            let set1 = assignmentToSet(assignment: assignment1st)
            let set2 = assignmentToSet(assignment: assignment2nd)

            if !set1.intersection(set2).isEmpty {
                overlapCount += 1
            }
        }

        return overlapCount
    }

    private func assignmentToSet(assignment: String) -> Set<Int> {
        let range = assignment.components(separatedBy: "-")
        assert(range.count == 2, "Incorrect range specified (more than 2 components)")

        let (bottom, top) = (Int(range.first!)!, Int(range.last!)!)

        return Set(bottom...top)
    }
}
