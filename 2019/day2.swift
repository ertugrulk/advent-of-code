import Foundation

let opcodes = readInput(day: 2)[0].components(separatedBy: ",").map { Int($0)! }
part1()

func part1() {
    var data = opcodes
    data[1] = 12
    data[2] = 2
    let result = executeOpcodes(opcodes: data)
    print("1202 program alarm state: \(result)")
}


func executeOpcodes(opcodes: [Int]) -> Int {
    var data = opcodes
    for i in stride(from: 0, to: data.count - 1, by: 4) {
        let op = data[i]
        let arg1Position = data[i + 1]
        let arg2Position = data[i + 2]
        let resultPosition = data[i + 3]
        switch (op)
        {
            case 1:
                data[resultPosition] = data[arg1Position] + data[arg2Position]
            case 2:
                data[resultPosition] = data[arg1Position] * data[arg2Position]
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