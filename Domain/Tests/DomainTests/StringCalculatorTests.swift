import XCTest
@testable import Domain

/// One test per rule of the kata, written in the order the rules were added.
final class StringCalculatorTests: XCTestCase {

    private var calculator: StringCalculator!

    override func setUp() {
        super.setUp()
        calculator = StringCalculator()
    }

    func testEmptyStringReturnsZero() throws {
        XCTAssertEqual(try calculator.add(""), 0)
    }

    func testNilReturnsZero() throws {
        XCTAssertEqual(try calculator.add(nil), 0)
    }

    func testOneNumberReturnsThatNumber() throws {
        XCTAssertEqual(try calculator.add("6"), 6)
    }

    func testTwoNumbersAreSummed() throws {
        XCTAssertEqual(try calculator.add("1,2"), 3)
    }

    func testManyNumbersAreSummed() throws {
        XCTAssertEqual(try calculator.add("1,2,3,4,5,6,7,8,9"), 45)
    }

    func testNewlineIsAlsoADelimiter() throws {
        XCTAssertEqual(try calculator.add("1\n2,3"), 6)
    }

    func testCustomDelimiterIsSupported() throws {
        XCTAssertEqual(try calculator.add("//;\n1;2"), 3)
    }

    func testNegativeNumbersAreRejected() {
        XCTAssertThrowsError(try calculator.add("1,-2")) { error in
            XCTAssertEqual(error as? StringCalculatorError, .negativesNotAllowed([-2]))
            XCTAssertEqual("\(error)", "negatives not allowed: -2")
        }
    }

    func testEveryNegativeNumberIsReported() {
        XCTAssertThrowsError(try calculator.add("-1,2,-3")) { error in
            XCTAssertEqual(error as? StringCalculatorError, .negativesNotAllowed([-1, -3]))
            XCTAssertEqual("\(error)", "negatives not allowed: -1, -3")
        }
    }

    func testNumbersGreaterThanOneThousandAreIgnored() throws {
        XCTAssertEqual(try calculator.add("2,1001"), 2)
    }

    func testOneThousandIsIncluded() throws {
        XCTAssertEqual(try calculator.add("1000"), 1000)
    }

    static var allTests = [
        ("testEmptyStringReturnsZero", testEmptyStringReturnsZero),
        ("testNilReturnsZero", testNilReturnsZero),
        ("testOneNumberReturnsThatNumber", testOneNumberReturnsThatNumber),
        ("testTwoNumbersAreSummed", testTwoNumbersAreSummed),
        ("testManyNumbersAreSummed", testManyNumbersAreSummed),
        ("testNewlineIsAlsoADelimiter", testNewlineIsAlsoADelimiter),
        ("testCustomDelimiterIsSupported", testCustomDelimiterIsSupported),
        ("testNegativeNumbersAreRejected", testNegativeNumbersAreRejected),
        ("testEveryNegativeNumberIsReported", testEveryNegativeNumberIsReported),
        ("testNumbersGreaterThanOneThousandAreIgnored", testNumbersGreaterThanOneThousandAreIgnored),
        ("testOneThousandIsIncluded", testOneThousandIsIncluded),
    ]
}
