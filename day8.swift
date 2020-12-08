import Foundation

var data = readInput(day: 8).map { Instruction(data: $0) }
part1()

func part1() {
    var acc = 0
    var i = -1
    repeat {
        i += 1
        if (data[i].executed) {
            print("Accumulator value before the second run is \(acc)")
            return
        } else {
            data[i].execute(acc: &acc, offset: &i)
        }
    } while true
}


struct Instruction {
    let op: String
    let value: Int
    var executed: Bool
}

extension Instruction{
    init(data: String) {
        let components = data.components(separatedBy: " ")
        self.op = components[0]
        self.value = Int(components[1])!
        self.executed = false
    }

    mutating func execute(acc: inout Int, offset: inout Int) {
        switch (self.op) {
            case "acc":
                acc += self.value
            case "jmp":
                offset += self.value - 1
            default: // nop
                break
        }
        self.executed = true
    }

    mutating func markAsExecuted() {
        self.executed = true
    }
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}