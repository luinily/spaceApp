//
//  JsonToApodConvertorTests.swift
//  Alamofire
//
//  Created by Coldefy Yoann on 2016/07/16.
//  Copyright © 2016年 Alamofire. All rights reserved.
//

import XCTest
@testable import spaceApp

class JsonToApodConvertorTests: XCTestCase {
	// MARK: Subject under test
	
	var target: JsonToApodConvertor!
	var data: Data!
	
	let jsonObject: [String: AnyObject] = [
		"copyright": "copyright",
		"date": "2016-07-16",
		"explanation": "explanation",
		"hdurl": "http://apod.nasa.gov/apod/image/1607/NGC2736NBbicolor_1250_Jurasevich.jpg",
		"media_type": "image",
		"service_version": "v1",
		"title": "title",
		"url": "http://apod.nasa.gov/apod/image/1607/NGC2736NBbicolor_1250_Jurasevich1024c.jpg"
	]
}

// MARK: Test lifecycle
extension JsonToApodConvertorTests {
	override func setUp() {
		target = JsonToApodConvertor()
		data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
	}
	
	override func tearDown() {
		
	}
}

// MARK: Test setup
extension JsonToApodConvertorTests {
	func dateFor2016_07_16() -> Date {
		let calendar = Calendar(identifier: .gregorian)
		var components = DateComponents()
		components.day = 16
		components.month = 07
		components.year = 2016
		components.hour = 0
		components.minute = 0
		return calendar.date(from: components)!
	}
}

// MARK: Test doubles
extension JsonToApodConvertorTests {
	
}

// MARK: Tests
extension JsonToApodConvertorTests {
	func test_convertDataToApodData_Copyright() {
		// Arrange
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
			
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.copyright, "copyright")
	}
	
	func test_convertDataToApodData_date() {
		// Arrange
		let date = dateFor2016_07_16()
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
		
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.date, date)
	}
	
	func test_convertDataToApodData_Explanation() {
		// Arrange
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
		
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.explanation, "explanation")
	}
	
	func test_convertDataToApodData_hdURL() {
		// Arrange
		let url = URL(string: "http://apod.nasa.gov/apod/image/1607/NGC2736NBbicolor_1250_Jurasevich.jpg")!
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.hdUrl, url)
	}
	
	func test_convertDataToApodData_Title() {
		// Arrange
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
		
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.title, "title")
	}
	
	func test_convertDataToApodData_url() {
		// Arrange
		let url = URL(string: "http://apod.nasa.gov/apod/image/1607/NGC2736NBbicolor_1250_Jurasevich1024c.jpg")!
		
		// Act
		let apodData = try? target.convertDataToApodData(data: data)
		
		// Assert
		guard let apod = apodData else {
			XCTAssert(false, "convertDataToApodData did not end correctly")
			return
		}
		
		XCTAssertEqual(apod.url, url)
	}
	
}
