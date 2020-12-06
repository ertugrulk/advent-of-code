import Foundation

let goal = 2020

let array = readInput(day: 1).map { Int($0)! }
findPart1()
findPart2()

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

func findPart1() {
    firstLoop: for i1 in 0..<array.count {
        for i2 in 1..<array.count {
            if (array[i1] + array[i2] == goal){
                let multiplicationResult = array[i1] * array[i2]
                print("Found the first part: \(array[i1]) + \(array[i2]) = \(goal) !")
                print("Multiplying them together produces \(multiplicationResult)")
                break firstLoop
            }
        }
    }
}

func findPart2() {
    firstLoop: for i1 in 0..<array.count {
        for i2 in 0..<array.count {
            for i3 in 0..<array.count {
                if (array[i1] + array[i2] + array[i3] == goal){
                    let multiplicationResult = array[i1] * array[i2] * array[i3]
                    print("Found the second part: \(array[i1]) + \(array[i2]) + \(array[i3]) = \(goal) !")
                    print("Multiplying them together produces \(multiplicationResult)")
                    break firstLoop
                }
            }
        }
    }
}

