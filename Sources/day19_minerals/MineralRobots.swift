import Foundation

struct Blueprint {
    let number: Int

    let oreRobotCost: [MaterialType: Int]
    let clayRobotCost: [MaterialType: Int]
    let obsidianRobotCost: [MaterialType: Int]
    let geodeRobotCost: [MaterialType: Int]
}

typealias Production = [MaterialType: Int]

enum MaterialType: Int, CustomStringConvertible {
    case ore
    case clay
    case obsidian
    case geode

    var description: String {
        switch self {
            case .ore: return "ore"
            case .clay: return "clay"
            case .obsidian: return "obsidian"
            case .geode: return "geode"
        }
    }
}

class MineralRobots {
    func calculateQualityLevels(input: [String]) -> Int {
        let blueprints = input.map { line in
            parseInput(line: line)
        }

        let qualityLevels: [Int] = blueprints.map { blueprint in
            blueprint.number * calculateOpenedGeodes(blueprints: blueprint, maxTime: 24)
        }

        return qualityLevels.reduce(0, +)
    }

    func calculateMaxGeodes(input: [String]) -> Int {
        let blueprints = input.map { line in
            parseInput(line: line)
        }.enumerated()
        .filter { idx, _ in idx <= 2 }
        .map { _, value in value }

        let results: [Int] = blueprints.map { blueprint in
            calculateOpenedGeodes(blueprints: blueprint, maxTime: 32)
        }

        return results.reduce(1, *)
    }

    struct SearchState: Equatable, Hashable {
        var minute: Int
        var productionPerMinute: [MaterialType: Int]
        var totalMaterials: [MaterialType: Int]

        func hash(into hasher: inout Hasher) {
            hasher.combine(minute)
            hasher.combine(productionPerMinute)
            hasher.combine(totalMaterials)
        }

        static func == (lhs: SearchState, rhs: SearchState) -> Bool {
            lhs.minute == rhs.minute && lhs.totalMaterials == rhs.totalMaterials && lhs.productionPerMinute == rhs.productionPerMinute
        }
    }

    private func calculateOpenedGeodes(blueprints: Blueprint, maxTime: Int) -> Int {
        var stateCache: Set<SearchState> = Set()

        let initialSearchState = SearchState(
                minute: 1,

                productionPerMinute: [
                    .ore: 1,
                    .clay: 0,
                    .obsidian: 0,
                    .geode: 0,
                ],

                totalMaterials: [
                    .ore: 0,
                    .clay: 0,
                    .obsidian: 0,
                    .geode: 0,
                ]
        )

        var queue: [SearchState] = [initialSearchState]
        var maxGeodeOpened = 0
        var bestFirstGeodeMinute = 1000
        let startTime = DispatchTime.now().uptimeNanoseconds

        while !queue.isEmpty {
            let searchState = queue.removeLast()
            let productionPerMin = searchState.productionPerMinute
            let totalMaterials = searchState.totalMaterials

            if maxGeodeOpened < totalMaterials[.geode]! {
                print("\tCurrent max geode opened is: \(maxGeodeOpened) [queue: \(queue.count)]")
                maxGeodeOpened = totalMaterials[.geode]!
            }

            if searchState.minute > maxTime {
                continue
            }

            if productionPerMin[.geode]! > 0 && searchState.minute < bestFirstGeodeMinute {
                bestFirstGeodeMinute = searchState.minute
            }

            let candidates = generateCandidates(nextMinute: searchState.minute + 1, totalMaterials: totalMaterials, productionPerMin: productionPerMin, blueprint: blueprints)
                    .map { candidate in
                        let newTotalMaterials = Dictionary(
                                uniqueKeysWithValues: candidate.totalMaterials.map { material, amount in
                                    (material, amount + productionPerMin[material]!)
                                }
                        )

                        return SearchState(
                                minute: candidate.minute,
                                productionPerMinute: candidate.productionPerMinute,
                                totalMaterials: newTotalMaterials)
                    }


            candidates.forEach { newState in

                if stateCache.contains(newState) {
                    return
                }

                let currentGeodeProduction = newState.productionPerMinute[.geode]!
                let minutesLeft = maxTime - newState.minute + 1
                var maxGeodesPossibleOpen = newState.totalMaterials[.geode]!
                for i in 0..<minutesLeft {
                    maxGeodesPossibleOpen += currentGeodeProduction + i
                }
                if maxGeodesPossibleOpen < maxGeodeOpened {
                    return
                }


                if filterHopelessCases(searchState: newState, blueprints: blueprints, bestFirstGeodeMinute: bestFirstGeodeMinute) {
                    queue.append(newState)
                    stateCache.insert(newState)
                }
            }
        }

        let diff = DispatchTime.now().uptimeNanoseconds - startTime
        print("Max geode opened for blueprint \(blueprints.number) is \(maxGeodeOpened) [time: \(diff/1_000_000)ms]")

        return maxGeodeOpened
    }

    private func filterHopelessCases(searchState: SearchState, blueprints: Blueprint, bestFirstGeodeMinute: Int) -> Bool {
        let maxOreCost = [blueprints.oreRobotCost[.ore]!, blueprints.clayRobotCost[.ore]!, blueprints.obsidianRobotCost[.ore]!, blueprints.geodeRobotCost[.ore]!].max()!
        let maxClayCost = [blueprints.oreRobotCost[.clay] ?? 0, blueprints.clayRobotCost[.clay] ?? 0, blueprints.obsidianRobotCost[.clay] ?? 0, blueprints.geodeRobotCost[.clay] ?? 0].max()!

        // too much ore production
        if searchState.productionPerMinute[.ore]! > maxOreCost {
            return false
        }

        // too much clay production
        if searchState.productionPerMinute[.clay]! > maxClayCost {
            return false
        }

        // drop cases which are unlikely to be successful
        if searchState.productionPerMinute[.geode]! == 0 && searchState.minute >= bestFirstGeodeMinute + 2 {
            return false
        }

        if searchState.minute >= 20 && searchState.productionPerMinute[.obsidian] == 0 {
            return false
        }

//        // not enough time to build geode opening robots (lack of obsidian)
//        let geodeObsidianReqs = blueprints.geodeRobotCost[.obsidian]!
//        if searchState.minute >= (maxTime - (geodeObsidianReqs - 1)) && productionPerMin[.obsidian]! == 0 {
//            continue
//        }
//
//        // not enough time to build geode opening robots (lack of clay for obsidian robot)
//        if searchState.minute >= (maxTime - (geodeObsidianReqs - 1)) - 1 && productionPerMin[.obsidian]! == 0 && productionPerMin[.clay]! == 0 {
//            continue
//        }
//
//        // nothing has been really started
//        if searchState.minute >= 10 && productionPerMin[.obsidian]! == 0 && productionPerMin[.clay]! == 0 && productionPerMin[.ore]! <= 1 {
//            continue
//        }

        return true
    }

    private func generateCandidates(nextMinute: Int, totalMaterials: [MaterialType: Int], productionPerMin: [MaterialType: Int], blueprint: Blueprint) -> [SearchState] {
        var candidates: [SearchState] = []

        let searchState = SearchState(minute: nextMinute, productionPerMinute: productionPerMin, totalMaterials: totalMaterials)

        let (geodeBuildState, couldBuildGeode) = attemptBuildRobot(currentSearchState: searchState, blueprints: blueprint, material: .geode)
        if couldBuildGeode {
            return [geodeBuildState]
        }

        let (obsidianBuildState, couldBuildObsidian) = attemptBuildRobot(currentSearchState: searchState, blueprints: blueprint, material: .obsidian)
        let geodeCosts = blueprint.geodeRobotCost
        if geodeCosts[.obsidian]! > totalMaterials[.obsidian]! {
            if couldBuildObsidian {
                candidates.append(obsidianBuildState)
            }
        }

        let (oreBuildState, couldBuildOre) = attemptBuildRobot(currentSearchState: searchState, blueprints: blueprint, material: .ore)
        if couldBuildOre {
            candidates.append(oreBuildState)
        }

        let (clayBuildState, couldBuildClay) = attemptBuildRobot(currentSearchState: searchState, blueprints: blueprint, material: .clay)
        if couldBuildClay {
            candidates.append(clayBuildState)
        }


        // nought state
        candidates.append(searchState)

        return candidates
    }

    private func attemptBuildRobot(currentSearchState: SearchState, blueprints: Blueprint, material: MaterialType) -> (SearchState, Bool) {
        var costs: Production = [:]

        switch material {
            case .ore:
                costs = blueprints.oreRobotCost
            case .clay:
                costs = blueprints.clayRobotCost
            case .obsidian:
                costs = blueprints.obsidianRobotCost
            case .geode:
                costs = blueprints.geodeRobotCost
        }

        let productionPerMin = currentSearchState.productionPerMinute
        let totalMaterials = currentSearchState.totalMaterials

        let (newTotalMaterials, canAfford) = subtract(materials1: totalMaterials, materials2: costs)

        if canAfford {
            let newProduction = modify(map: productionPerMin, change: 1, materials: material)
            return (SearchState(minute: currentSearchState.minute, productionPerMinute: newProduction, totalMaterials: newTotalMaterials), canAfford)
        } else {
            return (SearchState(minute: currentSearchState.minute, productionPerMinute: productionPerMin, totalMaterials: totalMaterials), canAfford)
        }
    }

    private func subtract(materials1: Production, materials2: Production) -> (Production, Bool) {
        let newMaterials = Dictionary(
                uniqueKeysWithValues: materials1.map { material, total in
                    (material, total - (materials2[material] ?? 0))
                }
        )

        let canAfford = !newMaterials.values.contains { $0 < 0 }

        if canAfford {
            return (newMaterials, canAfford)
        } else {
            return (materials1, canAfford)
        }
    }

    private func modify(map: Production, change: Int, materials: MaterialType...) -> Production {
        Dictionary(
            uniqueKeysWithValues: map.map { material, value in
                if materials.contains(material) {
                    return (material, value + 1)
                } else {
                    return (material, value)
                }
            }
        )
    }

    private func parseInput(line: String) -> Blueprint {
        let captures = Util.firstRegexMatch(
                string: line,
                pattern: #"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."#
        )!
        return Blueprint(
                number: Int(captures[1])!,
                oreRobotCost: [.ore: Int(captures[2])!],
                clayRobotCost: [.ore: Int(captures[3])!],
                obsidianRobotCost: [.ore: Int(captures[4])!, .clay: Int(captures[5])!],
                geodeRobotCost: [.ore: Int(captures[6])!, .obsidian: Int(captures[7])!]
        )
    }
}