import Foundation

let array = readInput(path: "day2-input.txt")
validatePasswords(part: "first", validator: part1Validator)
validatePasswords(part: "second", validator: part2Validator)


struct passwordEntry{
    let param1: Int
    let param2: Int
    let character: Character
    let password: String
}


func readInput(path: String) -> [String]{
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

func splitPassword(_ password: String) -> passwordEntry {
    let groups = password.groups(for: #"(\d+)-(\d+)\s(\w):\s(\w+)"#)[0]
    return passwordEntry(param1: Int(groups[1])!, 
    param2: Int(groups[2])!, 
    character: groups[3][groups[3].startIndex],
    password: groups[4])
}

func part1Validator(_ password: String) -> Bool {
    let entry = splitPassword(password)
    let occurences = entry.password.findOccurencesOfCharacter(of: entry.character)
    let isValid = occurences >= entry.param1 && occurences <= entry.param2
    return isValid
}

func part2Validator(_ password: String) -> Bool {
    let entry = splitPassword(password)
    let idx = entry.password.startIndex
    let param1Character = entry.password[entry.password.index(idx, offsetBy: entry.param1 - 1)]
    let param2Character = entry.password[entry.password.index(idx, offsetBy: entry.param2 - 1)]    
    let isValid = (param1Character == entry.character && param2Character != entry.character) || 
    (param2Character == entry.character && param1Character != entry.character)
    return isValid
}
func validatePasswords(part: String, validator: (String) -> Bool) {
    var count = 0
    for password in array {
        if (validator(password)) {
            count += 1
        }
    }
    print("For the \(part) part, found \(count) valid password(s)")
}


extension String {
    func findOccurencesOfCharacter(of character: Character) -> Int {
        var result = 0
        for char in self {
            if char == character {
                result += 1
            }
        }
        return result
    }
    func groups(for regexPattern: String) -> [[String]] {
    do {
        let text = self
        let regex = try NSRegularExpression(pattern: regexPattern)
        let matches = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return matches.map { match in
            return (0..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return ""
                }
                return String(text[range])
            }
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
}