import Foundation

let seats = readInput(day: 5).map { Seat(data: $0) }
part1()
part2()

func part1() {
    let highestSeatId = seats.reduce(0, { max($0, $1.seatId) })
    print("The highest seat id is \(highestSeatId)")
}

func part2() {
    let seatIds = seats.map { $0.seatId }
    let lowestSeatId = seatIds.min()!
    let highestSeatId = seatIds.max()!
    var seatId = 0
    for id in lowestSeatId...highestSeatId {
        if (!seatIds.contains(id) )  {
            seatId = id
        }
    }
    print("Your seat id is \(seatId)")
}


func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

struct Seat {
    let row: Int
    let column: Int
}

extension Seat : Equatable {
    static func ==(lhs: Seat, rhs: Seat) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}

extension Seat{
    var seatId: Int {
        return (self.row * 8) + self.column
    }

    init(data: String) {
        let index = data.index(data.startIndex, offsetBy: 7)
        let row = String(data[..<index]).replacingOccurrences(of: "F", with: "0").replacingOccurrences(of: "B", with: "1")
        let column = String(data[index...]).replacingOccurrences(of: "L", with: "0").replacingOccurrences(of: "R", with: "1")
        self.row = Int(row, radix:2)!
        self.column = Int(column, radix:2)!
    }
}