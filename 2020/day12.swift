import Foundation

var data = readInput(day: 12).map{ instruction(data: $0) }

part1() 

func part1(){
    let startingPoint = Point(0, 0)
    var pos = startingPoint
    for instruction in data {
        pos.navigate(instruction: instruction)

    }
    let distance = startingPoint.measureDistance(to: pos)
    print("Part 1: \(distance)")
}


enum action : String {
    case west = "W"
    case north = "N"
    case east = "E"
    case south = "S"
    case left = "L"
    case right = "R"
    case forward = "F"
} 

enum direction : Int {
    case west = 270, north = 0, east = 90, south = 180
} 

extension direction {
    mutating func addDegrees(_ degrees: Int) {
        var result = (self.rawValue + degrees) % 360
        result += result < 0 ? 360 : 0
        self = direction(rawValue: result)!
    }
    static func fromAction(action: action) -> direction? {
        switch(action){
            case .east: 
                return .east
            case .north: 
                return .north
            case .west: 
                return .west
            case .south:
                return .south
            case .forward, .left, .right:
                return nil
        }
    }
}



struct Point{
    var x: Int
    var y: Int
    var direction : direction = .east
}

extension Point {
    init(_ x: Int, _ y: Int){
        self.x = x
        self.y = y

    }

    func measureDistance(to: Point) -> Int {
        return abs(self.x - to.x) + abs(self.y - to.y) 
    }
    mutating func navigate(direction: direction, units: Int){
        switch(direction){    
            case .east:
                self.x += units
            case .north:
                self.y -= units
            case .south: 
                self.y += units
            case .west: 
                self.x -= units
        }
    }
    mutating func navigate(instruction: instruction) {
        switch(instruction.action) {
            case .east, .north, .south, .west: 
                self.navigate(direction: .fromAction(action: instruction.action)!, units: instruction.units)
            case .left:
                self.direction.addDegrees(-instruction.units)
            case .right:
                self.direction.addDegrees(instruction.units)
            case .forward:
                self.navigate(direction: self.direction, units: instruction.units)
        }
    }
}

struct instruction {
    let action: action
    let units: Int
}

extension instruction {
    init(data: String){
        self.action = day12.action(rawValue: String(data.first!))!
        self.units = Int(data[data.index(after: data.startIndex)...])!
    }
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}
