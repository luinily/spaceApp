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
}

// MARK: Test lifecycle
extension NetworkApodStoreTests {
	override func setUp() {
		mockNetworkTool = MockNetworkTool()
		target = NetworkApodStore(networkTool: mockNetworkTool)
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
}
