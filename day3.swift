import Foundation 

var array = readInput(day: 3)

struct Slope{
    let x: Int
    let y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
} 

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

var len = array[0].count

func getTreeCountByTravelling(slope: Slope) -> Int{ 
    var treeCount = 0
    var x = 0
    var y = 0
    while y < array.count-1 {
        x += slope.x
        y += slope.y
        if(x >= len) {
            x -= len
        }
        let line = array[y]
        let char = line[line.index(line.startIndex, offsetBy: x)]
        if(char == "#") {
            treeCount += 1
        }
    }
    return treeCount
}

let part1TreeCount = getTreeCountByTravelling(slope: Slope(3, 1))
print("Part 1 tree count: \(part1TreeCount)")

let part2Slopes = [
    Slope(1,1),
    Slope(3,1),
    Slope(5,1),
    Slope(7,1),
    Slope(1,2),
]

var part2TreeCount = part2Slopes
    .map { slope in getTreeCountByTravelling(slope: slope)}
    .reduce(1, *)

print("Part 2 tree count: \(part2TreeCount)")
