//
//  ApodWorkerTests.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

@testable import spaceApp
import XCTest

class ApodWorkerTests: XCTestCase {
	// MARK: Subject under test
	var target: ApodWorker!
	var mockStore: MockApodStore!
}

// MARK: Test lifecycle
extension ApodWorkerTests {
	override func setUp() {
		super.setUp()
		setupApodWorker()
	}

	override func tearDown() {
		super.tearDown()
	}
}

// MARK: Test setup
extension ApodWorkerTests {
	func setupApodWorker() {
		mockStore = MockApodStore()
		target = ApodWorker(apodStore: mockStore)
	}
}

// MARK: Test doubles
extension ApodWorkerTests {
	class MockApodStore: ApodStore {
		var fetchTodaysPictureCalled = false
		var fetchPictureForRandomDateCalled = false
		var shouldReturnData = true

		func fetchTodaysPicture(completionHandler: ApodCompletionHandler) {
			fetchTodaysPictureCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}

		func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler) {

		}

		func fetchPictureForRandomDate(completionHandler: ApodCompletionHandler) {
			fetchPictureForRandomDateCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}

		func handleCompletionHandler(completionHandler: ApodCompletionHandler) {
			if shouldReturnData {
				let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: Date(), explanation: "", copyright: "")
				completionHandler(apodData, nil)
			} else {
				let error = DownloadError.invalidData
				completionHandler( nil, error)
			}
		}
	}
}

// MARK: Tests
extension ApodWorkerTests {
	func test_fetchTodayAPOD_callsStoreFetchTodaysPicture() {
		// Arrange

		// Act
		target.fetchTodayAPOD() {
			_, _ in

		}

		// Assert
		XCTAssertTrue(mockStore.fetchTodaysPictureCalled)
	}

	func test_fetchTodayAPOD_passesTheData() {
		// Arrange
		var didReturnData = false

		// Act
		target.fetchTodayAPOD() {
			data, _ in
			didReturnData = data != nil
		}

		// Assert
		XCTAssertTrue(didReturnData)
	}

	func test_fetchTodayApod_passesTheError() {
		// Arrange
		mockStore.shouldReturnData = false
		var didReturnError = false

		// Act
		target.fetchTodayAPOD() {
			_, error in
			didReturnError = error != nil
		}

		// Assert
		XCTAssertTrue(didReturnError)
	}

	func test_fetchRandomAPOD_callsStoreFetchTodaysPicture() {
		// Arrange

		// Act
		target.fetchRandomApod() {
			_, _ in

		}

		// Assert
		XCTAssertTrue(mockStore.fetchPictureForRandomDateCalled)
	}

	func test_fetchRandomAPOD_passesTheData() {
		// Arrange
		var didReturnData = false

		// Act
		target.fetchRandomApod() {
			data, _ in
			didReturnData = data != nil
		}

		// Assert
		XCTAssertTrue(didReturnData)
	}

	func test_fetchRandomApod_passesTheError() {
		// Arrange
		mockStore.shouldReturnData = false
		var didReturnError = false

		// Act
		target.fetchRandomApod() {
			_, error in
			didReturnError = error != nil
		}

		// Assert
		XCTAssertTrue(didReturnError)
	}
}
