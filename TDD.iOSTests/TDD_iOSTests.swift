//
//  TDD_iOSTests.swift
//  TDD.iOSTests
//
//  Created by Hamza JGUERIM on 2019/06/06.
//  Copyright © 2019 Hamza JGUERIM. All rights reserved.
//

import XCTest
import App

@testable import TDD_iOS

class TDD_iOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(App().text, "Hello, World!")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
