import Foundation

public enum StringCalculatorError: Error, Equatable, CustomStringConvertible {
    case invalidDelimiter
    case negativesNotAllowed([Int])

    public var description: String {
        switch self {
        case .invalidDelimiter:
            return "a custom delimiter must be followed by a newline"
        case .negativesNotAllowed(let values):
            return "negatives not allowed: " + values.map(String.init).joined(separator: ", ")
        }
    }
}

/// The String Calculator kata, used here to practise test-driven development.
///
/// Rules:
/// - an empty string (or `nil`) returns 0
/// - numbers are separated by commas or newlines
/// - a custom delimiter can be declared as `//<delimiter>\n...`
/// - negative numbers are rejected, and every negative is reported
/// - numbers greater than 1000 are ignored
public struct StringCalculator {

    private static let maximumValue = 1000

    public init() {}

    public func add(_ numbers: String?) throws -> Int {
        guard let numbers = numbers,
              !numbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return 0
        }

        let (body, delimiters) = try splitDelimiter(from: numbers)

        var negatives: [Int] = []
        var sum = 0

        for token in body.components(separatedBy: delimiters) {
            let trimmed = token.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty, let value = Int(trimmed) else {
                continue
            }

            if value < 0 {
                negatives.append(value)
            } else if value <= Self.maximumValue {
                sum += value
            }
        }

        if !negatives.isEmpty {
            throw StringCalculatorError.negativesNotAllowed(negatives)
        }

        return sum
    }

    private func splitDelimiter(from numbers: String) throws -> (String, CharacterSet) {
        guard numbers.hasPrefix("//") else {
            return (numbers, CharacterSet(charactersIn: ",\n"))
        }

        guard let newline = numbers.firstIndex(of: "\n") else {
            throw StringCalculatorError.invalidDelimiter
        }

        let delimiterStart = numbers.index(numbers.startIndex, offsetBy: 2)
        guard delimiterStart < newline else {
            throw StringCalculatorError.invalidDelimiter
        }

        let delimiter = String(numbers[delimiterStart..<newline])
        let body = String(numbers[numbers.index(after: newline)...])
        return (body, CharacterSet(charactersIn: delimiter))
    }
}
