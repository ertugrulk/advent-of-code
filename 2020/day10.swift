import Foundation

var data = readInput(day: 10).map { Int($0)! }
part1()

func part1() {
    let sortedAdapters = data.sorted()
    var diffByOne = 1
    var diffByThree = 1
    for i in 1..<sortedAdapters.count {
        let diff = sortedAdapters[i] - sortedAdapters[i - 1]
        if diff == 1 {
            diffByOne += 1
        }
        else if diff == 3 {
            diffByThree += 1
        }
    }
    print("1 jolt differences (\(diffByOne)) multiplied by 3 jolt differences (\(diffByThree)) is \(diffByOne * diffByThree)")
}


func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}