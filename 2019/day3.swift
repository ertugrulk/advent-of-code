import Foundation

var lines = readInput(day: 3).map { $0.components(separatedBy: ",") }

part1()
part2()

func part1() {
    let centralPort = Point(0, 0)
    let line1 = generateGrid(from: centralPort, paths: lines[0])
    let line2 = generateGrid(from: centralPort, paths: lines[1])
    let intersections = line1.intersection(line2)
    let distances = intersections.map { $0.measureDistance(to: centralPort) }
    let shortestDistance = distances.min()!
    print ("The shortest distance between the central port and the first crossing is \(shortestDistance)")
}

func part2() {
    let centralPort = Point(0, 0)
    let line1 = generateGrid(from: centralPort, paths: lines[0])
    let line2 = generateGrid(from: centralPort, paths: lines[1])
    let intersections = line1.intersection(line2)
    let distances = intersections.map { intersection in
        (line1.first{ $0 == intersection}!.steps + line2.first{ $0 == intersection}!.steps)
    }
    let shortestDistance = distances.min()!
    print ("The fewest combined steps between central port and the first crossing is \(shortestDistance)")
}

func generateGrid(from: Point, paths: [String]) -> Set<Point> {
    var pos = from
    var grid: [Point] = []
    for path in paths {
        let direction = String(path.first!)
        let length = Int(path[path.index(after: path.startIndex)...])!
        for _ in 1...length {
            pos.steps += 1
            switch(direction) {
                case "U":
                    pos.y += 1
                case "D":
                    pos.y -= 1
                case "R":
                    pos.x += 1
                case "L":
                    pos.x -= 1
                default:
                    print("invalid direction")
            }
            grid.append(pos)
        }
    }
    return Set(grid)
}

struct Point{
    var x: Int
    var y: Int
    var steps: Int
}

extension Point {
    init(_ x: Int, _ y: Int, _ steps: Int = 0){
        self.x = x
        self.y = y
        self.steps = steps
    }

    func measureDistance(to: Point) -> Int {
        return abs(self.x - to.x) + abs(self.y - to.y) 
    }
}
extension Point: Hashable{
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}