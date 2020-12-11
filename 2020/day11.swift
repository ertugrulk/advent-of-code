import Foundation

var data = readInput(day: 11).map { row in
    row.map { rowSeat in 
        seat(rawValue: String(rowSeat))!
    }
 }
part1()


func printLayout(rows: [[seat]]) {
    for row in rows {
        let mappedRow = row.map { $0.rawValue }.reduce("", +)
        print ( mappedRow )
    }
}

func part1() {
    var lastLayout = data
    
    repeat {
        let currentLayout = processSeatingLayout(rows: lastLayout)
        if (currentLayout == lastLayout) {
            break
        } else {
            lastLayout = currentLayout
        }
    } while true
    
    let occupiedSeatCount = lastLayout.map { row in
        row.filter { $0 == .occupied }.count
    }.reduce(0, +)
    print("After processing layouts, \(occupiedSeatCount) seats are occupied")
}

func getAdjacentSeatsFromRow(row: [seat], column: Int, includeMiddleSeat: Bool) -> [seat?] {
    return [row[optional: column - 1], includeMiddleSeat ? row[optional: column] : nil, row[optional: column + 1]]
}

func findAdjacentSeats(layout: [[seat]], row: Int, column: Int) -> [seat] {
    let previousRow : [seat] = row >= 1 ? layout[row - 1] : []
    let currentRow = layout[row]
    let nextRow : [seat] = row < layout.count - 1 ? layout[row + 1] : []
    let seats = getAdjacentSeatsFromRow(row: previousRow, column: column, includeMiddleSeat: true) +
    getAdjacentSeatsFromRow(row: currentRow, column: column, includeMiddleSeat: false) +
    getAdjacentSeatsFromRow(row: nextRow, column: column, includeMiddleSeat: true)  
    return seats.compactMap { $0 }
}

func isSeatOccupiable(adjacentSeats: [seat]) -> Bool{
    return adjacentSeats.allSatisfy { $0 != .occupied }
}

func canSeatBeEmptied(adjacentSeats: [seat]) -> Bool {
    return adjacentSeats.filter { $0 == .occupied }.count >= 4
}

func processSeatingLayout(rows: [[seat]] ) -> [[seat]] {
    var result : [[seat]] = []
    var processedRow : [seat]
    for x in 0..<rows.count {
        processedRow = []
        for y in 0..<rows[x].count {
            var seatState = rows[x][y]
            let adjacentSeats = findAdjacentSeats(layout: rows, row: x, column: y)
            if (seatState == .empty && isSeatOccupiable(adjacentSeats: adjacentSeats)) {
                seatState = seat.occupied
            } else if (seatState == .occupied && canSeatBeEmptied(adjacentSeats: adjacentSeats)) {
                seatState = seat.empty
            } 
            processedRow.append(seatState)
        }
        result.append(processedRow)
    }
    return result
}

enum seat : String {
    case occupied = "#"
    case empty = "L"
    case floor = "."
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}