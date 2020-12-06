import Foundation 
let array = readInput(path: "day4-input.txt")
let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

printValidPassportCount(part: "first", validator: part1Validator)
printValidPassportCount(part: "second", validator: part2Validator)


func readInput(path: String) -> [String]{
    let content = try! String(contentsOfFile:path)
    return content.components(separatedBy: CharacterSet.newlines)
}

func printValidPassportCount(part: String, validator: (String) -> Bool) {
    var result = 0
    var currentPassport = ""
    for line in array {
        if (line == "") {
            if (validator(currentPassport)) {
                result += 1
            }
            currentPassport = ""
        } else {
            currentPassport += line + " "
        }
    }
    print("For the \(part) part, found \(result) valid passports.")
}

func part1Validator(data: String) -> Bool {
    return requiredFields.allSatisfy { data.contains($0 + ":")}
}

func extractPassportField(components: [String], field: String) -> String {
    let fieldPrefix = "\(field):"
    if let line = components.first(where: { $0.starts(with: fieldPrefix) }) {
        let index = line.index(line.startIndex, offsetBy: 4)
        return String(line[index...])
    } else {
        return ""
    }
}

func part2Validator(data: String) -> Bool {
    let passport = Passport(data: data)
    return passport.validate()
}

struct Passport {
    let birthYear: Int
    let issueYear: Int
    let expirationYear: Int
    let height: String
    let hairColor: String
    let eyeColor: String
    let passportId: String
}

extension String{
    func validate(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
}

extension Passport {
    init(data: String) {
        let components = data.components(separatedBy:" ")
        let birthYear = extractPassportField(components: components, field: "byr")
        let issueYear = extractPassportField(components: components, field: "iyr")
        let expirationYear = extractPassportField(components: components, field: "eyr")
        let height = extractPassportField(components: components, field: "hgt")
        let hairColor = extractPassportField(components: components, field: "hcl")
        let eyeColor = extractPassportField(components: components, field: "ecl")
        let passportId = extractPassportField(components: components, field: "pid")
        self.birthYear = Int(birthYear) ?? 0
        self.issueYear = Int(issueYear) ?? 0
        self.expirationYear = Int(expirationYear) ?? 0
        self.height = height
        self.hairColor = hairColor
        self.eyeColor = eyeColor
        self.passportId = passportId
    }
}

extension Passport {
    private func validateHeight() -> Bool {
        if let index = height.index(of: "cm") {
            let heightValue = Int(height[..<index])!
            return heightValue >= 150 && heightValue <= 193
        }
        else if let index = height.index(of: "in") {
            let heightValue = Int(height[..<index])!
            return heightValue >= 59 && heightValue <= 76
        }
        else {
            return false
        }
    }
    private func validateEyeColor() -> Bool {
        return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(self.eyeColor)
    }

    private func validateBirthYear() -> Bool {
        return birthYear >= 1920 && birthYear <= 2002
    }

    private func validateIssueYear() -> Bool {
        return issueYear >= 2010 && issueYear <= 2020
    }

    private func validateExpirationYear() -> Bool {
        return expirationYear >= 2020 && expirationYear <= 2030
    } 

    private func validateHairColor() -> Bool {
        return hairColor.validate(regex: #"#[a-f0-9]{6}"#)
    }

    private func validatePassportId() -> Bool {
        return passportId.validate(regex: "^[0-9]{9}$")
    }

    func validate() -> Bool {
        return validateHeight() && validateIssueYear() && validateExpirationYear() &&
        validateBirthYear() && validateHairColor() && validateEyeColor() && validatePassportId()

    }
}



extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
