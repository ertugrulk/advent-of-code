import Foundation

var data = readInput(day: 6)
print("Summary of answere question counts is \(answeredQuestionCountSum())")

func answeredQuestionCountSum() -> Int {
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

func readInput(day: Int) -> [String]{
    let path = "inputs/day\(day)-input.txt"
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}