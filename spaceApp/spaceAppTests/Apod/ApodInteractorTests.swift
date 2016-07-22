//
//  ApodInteractorTests.swift
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

class ApodInteractorTests: XCTestCase {
	// MARK: Subject under test
	var target: ApodInteractor!
	var mochApodWorker: MockApodWorker!
	var mochOutput: MockOutput!
}

// MARK: Test lifecycle
extension ApodInteractorTests {
	override func setUp() {
		super.setUp()
		setupApodInteractor()
	}
	
	override func tearDown() {
		super.tearDown()
	}
}

// MARK: Test setup
extension ApodInteractorTests {
	func setupApodInteractor() {
		mochApodWorker = MockApodWorker()
		target = ApodInteractor(apodWorker: mochApodWorker)
		
		mochOutput = MockOutput()
		target.output = mochOutput
	}
}

// MARK: Test doubles
extension ApodInteractorTests {
	class MockApodStore: ApodStore {
		func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler) {
			
		}
		
		func fetchTodaysPicture(completionHandler: ApodCompletionHandler) {
			
		}
		
		func fetchPictureForRandomDate(completionHandler: ApodCompletionHandler) {
			
		}
	}
	
	class MockApodWorker: ApodWorker {
		var fetchTodayApodCalled = false
		var fetchRandomApodCalled = false
		
		var shouldReturnData = true
		init() {
			super.init(apodStore: MockApodStore())
		}
		
		override func fetchTodayAPOD(completionHandler: (apodData: ApodData?, error: NSError?) -> Void) {
			fetchTodayApodCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}
		
		override func fetchRandomApod(completionHandler: (apodData: ApodData?, error: NSError?) -> Void) {
			fetchRandomApodCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}
		
		private func handleCompletionHandler(completionHandler: (apodData: ApodData?, error: NSError?) -> Void) {
			if shouldReturnData {
				let apodData = ApodData(title: "", url: URL(string: "")!, hdUrl: URL(string: "")!, date: Date(), explanation: "", copyright: "")
				completionHandler(apodData: apodData, error: nil)
			} else {
				let error = NSError(domain: "", code: 0, userInfo: nil)
				completionHandler(apodData: nil, error: error)
			}
		}
	}
	
	class MockOutput: ApodInteractorOutput {
		var presentOutputCalled = false
		var presentErrorCalled = false
		
		func presentApod(response: ApodResponse) {
			presentOutputCalled = true
		}
		
		func presentError(response: ApodErrorResponse) {
			presentErrorCalled = true
		}
	}
}

// MARK: Tests
extension ApodInteractorTests {
	func test_fetchTodayApod_callsWorkerFetchTodayApod() {
		// Arrange
		let request = TodayApodRequest()
		
		// Act
		target.fetchTodayApod(request: request)
		
		// Assert
		XCTAssertTrue(mochApodWorker.fetchTodayApodCalled)
	}
	
	func test_fetchTodayApod_callsOutputPresentApod() {
		// Arrange
		let request = TodayApodRequest()
		
		// Act
		target.fetchTodayApod(request: request)
		
		// Assert
		XCTAssertTrue(mochOutput.presentOutputCalled)
	}
	
	func test_fetchTodayApod_callsOutputPresentError() {
		// Arrange
		let request = TodayApodRequest()
		mochApodWorker.shouldReturnData = false
		
		// Act
		target.fetchTodayApod(request: request)
		
		// Assert
		XCTAssertTrue(mochOutput.presentErrorCalled)
	}
	
	func test_fetchRandomApod_callsWorkerFetchRamdomApod() {
		// Arrange
		let request = RandomApodRequest()
		
		// Act
		target.fetchRandomApod(request: request)
		
		// Assert
		XCTAssertTrue(mochApodWorker.fetchRandomApodCalled)
	}
	
	func test_fetchRandomApod_callsOutputPresentApod() {
		// Arrange
		let request = RandomApodRequest()
		
		// Act
		target.fetchRandomApod(request: request)
		
		// Assert
		XCTAssertTrue(mochOutput.presentOutputCalled)
	}
	
	func test_fetchRandomApod_callsOutputPresentError() {
		// Arrange
		let request = RandomApodRequest()
		mochApodWorker.shouldReturnData = false
		
		// Act
		target.fetchRandomApod(request: request)
		
		// Assert
		XCTAssertTrue(mochOutput.presentErrorCalled)
	}
}
