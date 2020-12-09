import Foundation

let numbers = readInput(day: 9).map { Int($0)! }

let invalidNumber = findInvalidNumber()!
print("The number not matching its preamble is \(invalidNumber)")
let weakness = findWeakness(invalidNumber: invalidNumber)!
print("Encryption weakness is \(weakness)")

func findInvalidNumber() -> Int? {
    for i in 25..<numbers.count {
        if (!preambleContains(index: i)) {
            return numbers[i]
        }
    }
    return nil
}

func findWeakness(invalidNumber: Int) -> Int? {
    for i1 in 0..<numbers.count {
        for i2 in i1..<numbers.count {
            let range = numbers[i1...i2]
            let sum = range.reduce(0, +)
            if sum == invalidNumber {
                let min = range.min()!
                let max = range.max()!
                return min + max
            }
            if sum > invalidNumber {
                break
            }
        }
    }
    return nil
}

func preambleContains(index: Int) -> Bool {
    for i1 in index - 25..<index {
        for i2 in index - 24..<index {
            if numbers[i1] + numbers[i2] == numbers[index] {
                return true
            }
        }
    }
    return false
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}