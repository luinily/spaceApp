//
//  NetworkApodStoreTests.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import spaceApp

class NetworkApodStoreTests: XCTestCase {
	// MARK: Subject under test
	private var target: NetworkApodStore!
	private var mockNetworkTool: MockNetworkTool!
	private var dataConvertor: MockDataConvertor!
	
	private var requestURL = "requestURL"
	private var apiKey = "apiKey"
}

// MARK: Test lifecycle
extension NetworkApodStoreTests {
	override func setUp() {
		mockNetworkTool = MockNetworkTool()
		dataConvertor = MockDataConvertor()
		let url = URL(string: requestURL)!
		target = NetworkApodStore(requestURl: url, oldestPossibleDate: makeDate(for: "1900-01-01"), apiKey: apiKey, networkTool: mockNetworkTool, dataConvertor: dataConvertor)
	}
	
	override func tearDown() {
		
	}
}

// MARK: Test setup
extension NetworkApodStoreTests {
	func makeDate(for dateString: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: dateString)!
	}
}

// MARK: Test doubles
extension NetworkApodStoreTests {
	class MockNetworkTool: NetworkTool {
		var makeGetRequestCalled = false
		var requestURL: String?
		var key: String?
		var requestParameters: [String: String]?
		var dateParameter: Date?
		var shouldReturnError = false
		
		func makeGetRequest(url: URL, parameters: [String: String], completionHandler: RequestCompletionHandler) {
			makeGetRequestCalled = true
			requestURL = url.absoluteString
			key = parameters["api_key"]
			requestParameters = parameters
			
			if shouldReturnError {
				completionHandler(data: nil, error: NSError(domain: "", code: 0, userInfo: nil))
			} else {
				completionHandler(data: Data(), error: nil)
			}
		}
	}
	
	class MockDataConvertor: DataToApodDataConverter {
		var convertDataToApodDataHasBeenCalled = false
		
		
		func convertDataToApodData(data: Data) throws -> ApodData {
			convertDataToApodDataHasBeenCalled = true
			
			let url = URL(string: "google.com")
			return ApodData(title: "", url: url!, hdUrl: url!, date: Date(), explanation: "", copyright: "")
		}
	}
}

// MARK: Tests
extension NetworkApodStoreTests {
	func testFetchTodaysPicture_callsMakeGetRequest_True() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertTrue(mockNetworkTool.makeGetRequestCalled)
	}

	func testFetchTodaysPicture_urlIsCorrect() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.requestURL, requestURL)
	}
	
	func testFetchTodaysPicture_keyIsCorrect() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.key, apiKey)
	}
	
	func testFetchTodaysPicture_hasKeyParameter() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["api_key"], apiKey)
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func testFetchTodaysPicture_hasHDParameterAtTrue() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["hd"], "true")
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func testFetchTodaysPicture_WhenGotData_AskToConverterToApodData() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		// Assert
		XCTAssertTrue(dataConvertor.convertDataToApodDataHasBeenCalled)
	}
	
	func testFetchTodaysPicture_WhenGotData_CallsCompletionHandler() {
		// Arrange
		var completionHandlerHasBeenCalled = false
		// Act
		
		target.fetchTodaysPicture() {
			pictureData, error in
			completionHandlerHasBeenCalled = true
		}
		
		// Assert
		XCTAssertTrue(completionHandlerHasBeenCalled)
	}
	
	func testFetchTodaysPicture_WhenGotData_CallsCompletionHandlerWithApodData() {
		// Arrange
		var apodData: ApodData? = nil
		// Act
		
		target.fetchTodaysPicture() {
			pictureData, error in
			apodData = pictureData
		}
		
		// Assert
		XCTAssertNotNil(apodData)
	}
	
	func testFetchTodaysPicture_WhenHasError_CallsCompletionHandlerWithError() {
		// Arrange
		var error: NSError? = nil
		mockNetworkTool.shouldReturnError = true
		
		// Act
		target.fetchTodaysPicture() {
			pictureData, fetchError in
			error = fetchError
		}
		
		// Assert
		XCTAssertNotNil(error)
	}
	
	func test_fetchPictureFor_callsMakeGetRequest_True() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertTrue(mockNetworkTool.makeGetRequestCalled)
	}
	
	func test_fetchPictureFor_urlIsCorrect() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.requestURL, requestURL)
	}
	
	func test_fetchPictureFor_keyIsCorrect() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.key, apiKey)
	}
	
	func test_fetchPictureFor_hasHDParameterAtTrue() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["hd"], "true")
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func test_fetchPictureFor_hasValidDateParameter() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["date"], "2016-07-16")
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func test_fetchPictureFor_WhenGotData_AskToConverterToApodData() {
		// Arrange
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			(pictureData: ApodData?, error: NSError?) in
		}
		// Assert
		XCTAssertTrue(dataConvertor.convertDataToApodDataHasBeenCalled)
	}
	
	func test_fetchPictureFor_WhenGotData_CallsCompletionHandler() {
		// Arrange
		var completionHandlerHasBeenCalled = false
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			pictureData, error in
			completionHandlerHasBeenCalled = true
		}
		
		// Assert
		XCTAssertTrue(completionHandlerHasBeenCalled)
	}
	
	func test_fetchPictureFor_WhenGotData_CallsCompletionHandlerWithApodData() {
		// Arrange
		var apodData: ApodData? = nil
		// Act
		
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			pictureData, error in
			apodData = pictureData
		}
		
		// Assert
		XCTAssertNotNil(apodData)
	}
	
	func test_fetchPictureFor_WhenHasError_CallsCompletionHandlerWithError() {
		// Arrange
		var error: NSError? = nil
		mockNetworkTool.shouldReturnError = true
		
		// Act
		target.fetchPictureFor(date: makeDate(for: "2016-07-16")) {
			pictureData, fetchError in
			error = fetchError
		}
		
		// Assert
		XCTAssertNotNil(error)
	}
	
	func test_fetchPictureForRandomDate_callsMakeGetRequest_True() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertTrue(mockNetworkTool.makeGetRequestCalled)
	}
	
	func test_fetchPictureForRandomDate_urlIsCorrect() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.requestURL, requestURL)
	}
	
	func test_fetchPictureForRandomDate_keyIsCorrect() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		XCTAssertEqual(mockNetworkTool.key, apiKey)
	}
	
	func test_fetchPictureForRandomDate_hasKeyParameter() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["api_key"], apiKey)
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func test_fetchPictureForRandomDate_hasHDParameterAtTrue() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertEqual(parameters["hd"], "true")
		} else {
			XCTAssert(false) //should never be called
		}
	}
	
	func test_fetchPictureForRandomDate_WhenGotData_AskToConverterToApodData() {
		// Arrange
		
		// Act
		target.fetchPictureForRandomDate() {
			(pictureData: ApodData?, error: NSError?) in
		}
		// Assert
		XCTAssertTrue(dataConvertor.convertDataToApodDataHasBeenCalled)
	}
	
	func test_fetchPictureForRandomDate_WhenGotData_CallsCompletionHandler() {
		// Arrange
		var completionHandlerHasBeenCalled = false
		// Act
		
		target.fetchPictureForRandomDate() {
			pictureData, error in
			completionHandlerHasBeenCalled = true
		}
		
		// Assert
		XCTAssertTrue(completionHandlerHasBeenCalled)
	}
	
	func test_fetchPictureForRandomDate_WhenGotData_CallsCompletionHandlerWithApodData() {
		// Arrange
		var apodData: ApodData? = nil
		// Act
		
		target.fetchPictureForRandomDate() {
			pictureData, error in
			apodData = pictureData
		}
		
		// Assert
		XCTAssertNotNil(apodData)
	}
	
	func test_fetchPictureForRandomDate_WhenHasError_CallsCompletionHandlerWithError() {
		// Arrange
		var error: NSError? = nil
		mockNetworkTool.shouldReturnError = true
		
		// Act
		target.fetchPictureForRandomDate() {
			pictureData, fetchError in
			error = fetchError
		}
		
		// Assert
		XCTAssertNotNil(error)
	}
	
}
