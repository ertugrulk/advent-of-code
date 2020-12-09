import Foundation

let opcodes = readInput(day: 2)[0].components(separatedBy: ",").map { Int($0)! }
part1()
part2()

func part1() {
    let opcodes = prepareOpcodes(noun: 12, verb: 2)
    let result = executeOpcodes(opcodes: opcodes)
    print("Part1: 1202 program alarm state: \(result!)")
}

func part2() {
    let desiredOutput = 19690720
    mainLoop: for i1 in 0...1024 {
        for i2 in 0...1024 {
            let opcodes = prepareOpcodes(noun: i1, verb: i2)
            let result = executeOpcodes(opcodes: opcodes)
            if (result == desiredOutput) {
                let calculationResult = 100 * i1 + i2
                print("Part2: Required noun: \(i1) verb: \(i2).  Calculation \(calculationResult)")
                return
            }
        }
    }
}

func prepareOpcodes(noun: Int, verb: Int) -> [Int] {
    var data = opcodes
    data[1] = noun
    data[2] = verb
    return data
}

func executeOpcodes(opcodes: [Int]) -> Int?  {
    var data = opcodes
    for i in stride(from: 0, to: data.count - 1, by: 4) {
        guard let op = data[optional: i] else { return nil }
        guard let arg1Position = data[optional: i + 1] else { return nil }
        guard let arg2Position = data[optional: i + 2] else { return nil }
        guard let resultPosition = data[optional: i + 3] else { return nil }
        guard let arg1 = data[optional: arg1Position] else { return nil }
        guard let arg2 = data[optional: arg2Position] else { return nil }
        guard let _ = data[optional: resultPosition] else { return nil }
        switch (op)
        {
            case 1:
                data[resultPosition] = arg1 + arg2
            case 2:
                data[resultPosition] = arg1 * arg2
            case 99:
                break
            default:
                print("Unknown operation: \(op)")
        }
    }
    return data[0]
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}
