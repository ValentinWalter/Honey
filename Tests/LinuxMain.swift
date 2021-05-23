import XCTest

import HoneyTests

var tests = [XCTestCaseEntry]()
tests += HoneyTests.allTests()
XCTMain(tests)
