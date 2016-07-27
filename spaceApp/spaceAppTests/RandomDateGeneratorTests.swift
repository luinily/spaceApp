//
//  RandomDateGeneratorTests.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/27.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import spaceApp

class RandomDateGeneratorTests: XCTestCase {
	// MARK: Subject under test
}

// MARK: Test lifecycle
extension RandomDateGeneratorTests {
	override func setUp() {
	}
	
	override func tearDown() {
		
	}
}

// MARK: Test setup
extension RandomDateGeneratorTests {
	func makeDate(for dateString: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: dateString)!
	}
}

// MARK: Test doubles
extension RandomDateGeneratorTests {
	
}

// MARK: Tests
extension RandomDateGeneratorTests {
	func test_generateDate_dateWithingBounds() {
		// Arrange
		let lowerBound = makeDate(for: "1900-01-01")
		let higherBound =  makeDate(for: "2000-12-31")
		
		let target = RandomDateGenerator(lowerBound: lowerBound, higherBound:higherBound)
		for _ in 0 ... 100000 {
			// Act
			let date = target.generateDate()
			
			// Assert
			XCTAssertGreaterThanOrEqual(date, lowerBound)
			XCTAssertLessThanOrEqual(date, higherBound)
		}
	}
	
	func test_generateDate_dateParameterVaries() {
		// Arrange
		let lowerBound = makeDate(for: "1900-01-01")
		let higherBound =  makeDate(for: "2000-12-31")
		let target = RandomDateGenerator(lowerBound: lowerBound, higherBound:higherBound)
		
		var previousDate: Date? = nil
		var previousPreviousDate: Date? = nil
		
		for _ in 0 ... 100000 {
			// Act
			let currentDate = target.generateDate()
			
			//Assert
			
			if let previousDate = previousDate {
				if let previousPreviousDate = previousPreviousDate {
					let currentSameThanPrevious = currentDate == previousDate
					let previousSameThenPreviousPrevious = previousDate == previousPreviousDate
					XCTAssertFalse(currentSameThanPrevious && previousSameThenPreviousPrevious)
				}
				previousPreviousDate = previousDate
			}
			previousDate = currentDate
		}
	}

}
