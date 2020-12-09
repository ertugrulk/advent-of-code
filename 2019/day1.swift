import Foundation

let modules = readInput(day: 1).map { Int($0)! }
part1()
part2()

func part1() {
    let result = modules.map { calculateFuelRequirements(forMass: $0) }.reduce(0, +)
    print("Fuel requirements for all modules is \(result)")
}

func part2() {
    let result = modules.map { recursivelyCalculateFuelRequirements(forMass: $0) }.reduce(0, +)
    print("Fuel requirements for all modules including mass required for fuel is \(result)")
}

func calculateFuelRequirements(forMass: Int) -> Int {
    return max(0, (forMass / 3) - 2)
}

func recursivelyCalculateFuelRequirements(forMass: Int) -> Int {
    let requirements = calculateFuelRequirements(forMass: forMass)
    return requirements > 0 ? requirements + recursivelyCalculateFuelRequirements(forMass: requirements) : requirements
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}