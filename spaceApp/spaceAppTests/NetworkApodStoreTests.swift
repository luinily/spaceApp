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
}

// MARK: Test lifecycle
extension NetworkApodStoreTests {
	override func setUp() {
		mockNetworkTool = MockNetworkTool()
		dataConvertor = MockDataConvertor()
		target = NetworkApodStore(networkTool: mockNetworkTool, dataConvertor: dataConvertor)
	}
	
	override func tearDown() {
		
	}
}

// MARK: Test setup
extension NetworkApodStoreTests {
	
}

// MARK: Test doubles
extension NetworkApodStoreTests {
	class MockNetworkTool: NetworkTool {
		var makeGetRequestCalled = false
		var requestURL: String?
		var requestParameters: [String: String]?
		
		func makeGetRequest(url: String, parameters: [String: String], completionHandler: RequestCompletionHandler) {
			makeGetRequestCalled = true
			requestURL = url
			requestParameters = parameters
			completionHandler(data: Data(), error: nil)
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
		XCTAssertEqual(mockNetworkTool.requestURL, "https://api.nasa.gov/planetary/apod")
	}
	
	func testFetchTodaysPicture_hasNoParameters() {
		// Arrange
		
		// Act
		target.fetchTodaysPicture() {
			(pictureData: ApodData?, error: NSError?) in
		}
		
		// Assert
		if let parameters = mockNetworkTool.requestParameters {
			XCTAssertTrue(parameters.isEmpty)
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
}
