import Foundation

var data = readInput(day: 7).map { Bag(data: $0)}

part1()
part2()

func part1() {
    var count = 0
    for bag in data {
        if (bag.contains(color: "shiny gold")) {
            count += 1
        }
    }
    print("\(count) bags may contain shiny bags")
}

func part2() {
    let bag = data.first { $0.color == "shiny gold"}!
    let count = bag.childrenCount()
    print("\(bag.color) bag contains \(count) other bags")   
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}


struct Bag {
    var color: String
    var contents: [(amount: Int, color: String)]
}

extension Bag {
    init(data: String) {
        let components = data.components(separatedBy: " bags contain ")
        self.color = components[0]
        self.contents = components[1].components(separatedBy: ", ").compactMap { 
            let bagData = $0.components(separatedBy:" ")
            if(bagData[0] == "no"){
                return nil
            }
            return (Int(bagData[0])!, "\(bagData[1]) \(bagData[2])")
        }
    }

    func childrenCount() -> Int {
        let mappedContents = self.contents.map { content in (amount: content.amount, bag: data.first { $0.color == content.color })}
        var result = 0
        var count = 0
        for child in mappedContents {
            if let bag = child.bag {
                count = bag.childrenCount()
                result += (count * child.amount)
            }
            result += child.amount
        }
        return result
    }

    func contains(color: String) -> Bool {
        if (self.contents.contains(where: { $0.color == color })) {
            return true
        }
        let mappedContents = self.contents.compactMap { content in data.first { $0.color == content.color }}
        for child in mappedContents {
            if (child.contains(color: color)) {
                return true
            }
        }
        return false
    }
}