//
//  ApodDateConvertorTests.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/16.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import spaceApp

class DateConvertorTests: XCTestCase {
	// MARK: Subject under test
	fileprivate var target: ApodDateConvertor!
}

// MARK: Test lifecycle
extension DateConvertorTests {
	override func setUp() {
		target = ApodDateConvertor()
	}

	override func tearDown() {

	}
}

// MARK: Test setup
extension DateConvertorTests {

}

// MARK: Test doubles
extension DateConvertorTests {

}

// MARK: Tests
extension DateConvertorTests {
	func test_dateFromString_yearIsOk() {
		// Arrange
		let dateString = "2016-07-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		guard let checkedDate = date else {
			XCTAssert(false, "could not get Date object")
			return
		}

		let year = Calendar.current.component(.year, from: checkedDate)

		XCTAssertEqual(year, 2016)
	}

	func test_dateFromString_monthIsOk() {
		// Arrange
		let dateString = "2016-07-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		guard let checkedDate = date else {
			XCTAssert(false, "could not get Date object")
			return
		}

		let month = Calendar.current.component(.month, from: checkedDate)

		XCTAssertEqual(month, 07)
	}

	func test_dateFromString_dayIsOk() {
		// Arrange
		let dateString = "2016-07-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		guard let checkedDate = date else {
			XCTAssert(false, "could not get Date object")
			return
		}

		let day = Calendar.current.component(.day, from: checkedDate)

		XCTAssertEqual(day, 16)
	}

	func test_dateFromString_StringTooLong() {
		// Arrange
		let dateString = "2016-07-163"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		XCTAssertNil(date)
	}

	func test_dateFromString_StringTooShort() {
		// Arrange
		let dateString = "2016-7-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		XCTAssertNil(date)
	}

	func test_dateFromString_LettersInTheDate() {
		// Arrange
		let dateString = "2016-07-1a"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		XCTAssertNil(date)
	}

	func test_dateFromString_ImpossibleMonth_over12() {
		// Arrange
		let dateString = "2016-13-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		XCTAssertNil(date)
	}

	func test_dateFromString_ImpossibleMonth_before1() {
		// Arrange
		let dateString = "2016-00-16"

		// Act
		let date = target.dateFromString(dateString: dateString)

		// Assert
		XCTAssertNil(date)
	}
}
