import XCTest

import SigningTests

var tests = [XCTestCaseEntry]()
tests += SigningTests.allTests()
XCTMain(tests)
