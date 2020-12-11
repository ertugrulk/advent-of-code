import Foundation

var data = readInput(day: 11).map { row in
    row.map { rowSeat in 
        seat(rawValue: String(rowSeat))!
    }
 }


part1()
part2()

func part1() {
    let occupiedSeatCount = occupiedSeatCountAfterStabilization(
        ignoreFloorsWhenFindingAdjacentSeats: false, 
        maximumOccupancyForEmptyingSeats: 4)
    print("Part 1: \(occupiedSeatCount) seats are occupied")
}

func part2() {
    let occupiedSeatCount = occupiedSeatCountAfterStabilization(
        ignoreFloorsWhenFindingAdjacentSeats: true, 
        maximumOccupancyForEmptyingSeats: 5)
    print("Part 2: \(occupiedSeatCount) seats are occupied")
}

func occupiedSeatCountAfterStabilization(ignoreFloorsWhenFindingAdjacentSeats: Bool,  maximumOccupancyForEmptyingSeats: Int) -> Int {
    var lastLayout = data
    
    repeat {
        let currentLayout = processSeatingLayout(rows: lastLayout, 
        maximumOccupancyForEmptyingSeats: maximumOccupancyForEmptyingSeats,
        ignoreFloorsWhenFindingAdjacentSeats: ignoreFloorsWhenFindingAdjacentSeats
        )
        if (currentLayout == lastLayout) {
            break
        } else {
            lastLayout = currentLayout
        }
    } while true
    
    return lastLayout.map { row in
        row.filter { $0 == .occupied }.count
    }.reduce(0, +)
}

func getAdjacentSeatsFromRow(row: [seat], column: Int, includeMiddleSeat: Bool) -> [seat?] {
    return [row[optional: column - 1], includeMiddleSeat ? row[optional: column] : nil, row[optional: column + 1]]
}

func getFirstAdjacentSeat(layout: [[seat]], row: Int, column: Int, direction: direction, ignoreFloors: Bool) -> seat? {
    var x = column
    var y = row
    repeat {
        switch(direction){
            case .down: 
                y += 1
            case .downleft: 
                x -= 1
                y += 1
            case .downright:
                x += 1
                y += 1
            case .left:
                x -= 1
            case .right: 
                x += 1
            case .up:
                y -= 1
            case .upleft: 
                x -= 1
                y -= 1
            case .upright:
                x += 1
                y -= 1    
        }
        guard let row = layout[optional: y] else { return nil }
        guard let seat = row[optional: x] else { return nil }
        if ignoreFloors && seat == .floor {
            continue
        } else {
            return seat
        }
    } while true
}

func findAdjacentSeats(layout: [[seat]], row: Int, column: Int, ignoreFloors: Bool) -> [seat] {
    return direction.allCases.compactMap { getFirstAdjacentSeat(layout: layout, row: row, column: column, direction: $0, ignoreFloors: ignoreFloors) }
}

func isSeatOccupiable(adjacentSeats: [seat]) -> Bool{
    return adjacentSeats.allSatisfy { $0 != .occupied }
}

func canSeatBeEmptied(adjacentSeats: [seat], maximumOccupancy: Int) -> Bool {
    return adjacentSeats.filter { $0 == .occupied }.count >= maximumOccupancy
}

func processSeatingLayout(rows: [[seat]], 
    maximumOccupancyForEmptyingSeats: Int,
    ignoreFloorsWhenFindingAdjacentSeats: Bool) -> [[seat]] {
    var result : [[seat]] = []
    var processedRow : [seat]
    for row in 0..<rows.count {
        processedRow = []
        for column in 0..<rows[row].count {
            var seatState = rows[row][column]
            let adjacentSeats = findAdjacentSeats(layout: rows, row: row, column: column, ignoreFloors: ignoreFloorsWhenFindingAdjacentSeats)
            if (seatState == .empty && isSeatOccupiable(adjacentSeats: adjacentSeats)) {
                seatState = seat.occupied
            } else if (seatState == .occupied && canSeatBeEmptied(adjacentSeats: adjacentSeats,
             maximumOccupancy: maximumOccupancyForEmptyingSeats)) {
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

enum direction : CaseIterable {
    case up
    case down
    case left
    case right
    case upleft
    case upright
    case downleft
    case downright
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