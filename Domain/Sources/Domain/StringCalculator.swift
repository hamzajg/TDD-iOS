import Foundation

public enum StringCalculatorError: Error, Equatable, CustomStringConvertible {
    case invalidDelimiter
    case negativesNotAllowed([Int])

    public var description: String {
        switch self {
        case .invalidDelimiter:
            return "a custom delimiter must be a non-empty name, or [name] for anything longer"
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
/// - a delimiter of any length, or several of them, can be declared in brackets: `//[***]\n...` or `//[*][%]\n...`
/// - negative numbers are rejected, and every negative is reported
/// - numbers greater than 1000 are ignored
public struct StringCalculator {

    private static let maximumValue = 1000
    private static let defaultDelimiters = [",", "\n"]

    public init() {}

    public func add(_ numbers: String?) throws -> Int {
        guard let numbers = numbers,
              !numbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return 0
        }

        let (body, delimiters) = try splitDelimiter(from: numbers)

        var negatives: [Int] = []
        var sum = 0

        for token in split(body, by: delimiters) {
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

    /// Splits `body` on any of `delimiters`, taking the longest match at each
    /// position so `**` is never read as two `*` delimiters.
    private func split(_ body: String, by delimiters: [String]) -> [String] {
        let longestFirst = delimiters.sorted { $0.count > $1.count }
        var tokens: [String] = []
        var current = ""
        var index = body.startIndex

        while index < body.endIndex {
            if let match = longestFirst.first(where: { body[index...].hasPrefix($0) }) {
                tokens.append(current)
                current = ""
                index = body.index(index, offsetBy: match.count)
            } else {
                current.append(body[index])
                index = body.index(after: index)
            }
        }

        tokens.append(current)
        return tokens
    }

    private func splitDelimiter(from numbers: String) throws -> (String, [String]) {
        guard numbers.hasPrefix("//") else {
            return (numbers, Self.defaultDelimiters)
        }

        guard let newline = numbers.firstIndex(of: "\n") else {
            throw StringCalculatorError.invalidDelimiter
        }

        let headerStart = numbers.index(numbers.startIndex, offsetBy: 2)
        guard headerStart <= newline else {
            throw StringCalculatorError.invalidDelimiter
        }

        let header = String(numbers[headerStart..<newline])
        let body = String(numbers[numbers.index(after: newline)...])

        if header.hasPrefix("[") {
            var delimiters: [String] = []
            var rest = Substring(header)

            while !rest.isEmpty {
                guard rest.hasPrefix("["), let end = rest.firstIndex(of: "]") else {
                    throw StringCalculatorError.invalidDelimiter
                }
                let delimiter = rest[rest.index(after: rest.startIndex)..<end]
                guard !delimiter.isEmpty else {
                    throw StringCalculatorError.invalidDelimiter
                }
                delimiters.append(String(delimiter))
                rest = rest[rest.index(after: end)...]
            }

            guard !delimiters.isEmpty else {
                throw StringCalculatorError.invalidDelimiter
            }
            return (body, delimiters)
        }

        guard !header.isEmpty else {
            throw StringCalculatorError.invalidDelimiter
        }
        return (body, [header])
    }
}
