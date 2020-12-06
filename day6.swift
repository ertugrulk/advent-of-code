import Foundation

var data = readInput(day: 6)
print("Part1 - Sum of questions answered by anyone in group: \(questionsAnsweredByAnyoneInGroupSum())")
print("Part2 - Sum of questions answered by everyone in group: \(questionsAnsweredByEveryoneInGroupSum())")

func questionsAnsweredByAnyoneInGroupSum() -> Int {
    var currentLetters = ""
    var summary = 0
    for line in data {
        if (line == "" ) {
            summary += currentLetters.count
            currentLetters = ""
        }
        else {
            for char in line {
                if (!currentLetters.contains(char)) {
                    currentLetters += String(char)
                }
            }
        }
    }
    return summary
}

func questionsAnsweredByEveryoneInGroupSum() -> Int {
    var summary = 0
    var group: [String] = []
    for line in data {
        if (line == "") {
            let questionsToCheck = Array(group[0])
            let answeredByAll = questionsToCheck.filter { questionToCheck in
                group.allSatisfy { groupPerson in
                    Array(groupPerson).contains(questionToCheck)
                }
            }
            summary += answeredByAll.count
            group = []
        } else {
            group.append(line)
        }
    }
    return summary
}

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}