import Foundation

let instructions = readInput(day: 8).map { Instruction(data: $0) }
findAccValueAtLoopsEnd()
fixInfiniteLoop()

func findAccValueAtLoopsEnd() {
    let result = executeInstructions(instructions: instructions)
    print("Acc value at the end of the infinite loop is \(result.lastAccValue)")
}


func fixInfiniteLoop() {
    for i in 0..<instructions.count {
        var instructionsToTry = instructions
        if (["jmp","nop"].contains(instructionsToTry[i].op)) {
            instructionsToTry[i].revertOperation()
            let result = executeInstructions(instructions: instructionsToTry)
            if (!result.isInfiniteLoop) {
                print("Acc value after fixing infinite loop is \(result.lastAccValue)")
                return
            }
        }
    }
}


func executeInstructions(instructions: [Instruction]) -> (isInfiniteLoop: Bool, lastAccValue: Int) {
    var data = instructions
    let instructionCount = instructions.count
    var acc = 0
    var i = -1
    repeat {
        i += 1
        if (data[i].executed) {
            return (true, acc)
        } else {
            data[i].execute(acc: &acc, offset: &i)
        }
    } while i < instructionCount - 1
    return (false, acc)
}

struct Instruction {
    var op: String
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

    mutating func revertOperation() {
        self.op = self.op == "nop" ? "jmp" : "nop"
    }
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}