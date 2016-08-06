//
//  ApodPresenterTests.swift
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

class ApodPresenterTests: XCTestCase {
	// MARK: Subject under test
	var target: ApodPresenter!
	var mockOutput: MockOutput!
}

// MARK: Test lifecycle
extension ApodPresenterTests {
	override func setUp() {
		super.setUp()
		setupApodPresenter()
	}
	
	override func tearDown() {
		super.tearDown()
	}
}

// MARK: Test setup
extension ApodPresenterTests {
	func setupApodPresenter() {
		target = ApodPresenter()
		mockOutput = MockOutput()
		target.output = mockOutput
	}
	
	func makeDate(year: Int, month: Int, day: Int) -> Date {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = 0
		components.minute = 0
		
		return Calendar.current.date(from: components)!
	}
}

// MARK: Test doubles
extension ApodPresenterTests {
	class MockOutput: ApodPresenterOutput {
		var displayApodCalled = false
		var apodViewModel: ApodDataViewModel? = nil
		
		var displayApodErrorCalled = false
		var errorViewModel: ApodErrorViewModel? = nil
		
		var displayImageCalled = false
		var imageViewModel: ApodImageViewModel? = nil
		
		func displayApod(viewModel: ApodDataViewModel) {
			displayApodCalled = true
			self.apodViewModel = viewModel
		}
		
		func displayApodError(viewModel: ApodErrorViewModel) {
			displayApodErrorCalled = true
			errorViewModel = viewModel
		}
		
		func displayImage(viewModel: ApodImageViewModel) {
			displayImageCalled = true
			imageViewModel = viewModel
		}
	}
}

// MARK: Tests
extension ApodPresenterTests {
	func test_presentApod_callsDisplayAPOD() {
		// Arrange
		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: Date(), explanation: "", copyright: "")
		let response = ApodResponse(apodData: apodData)
		
		// Act
		target.presentApod(response: response)
		
		// Assert
		XCTAssertTrue(mockOutput.displayApodCalled)
	}
	
	func test_presentApod_viewModelContainsTitle() {
		// Arrange
		let title = "title"
		let apodData = ApodData(title: title, url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: Date(), explanation: "", copyright: "")
		let response = ApodResponse(apodData: apodData)
		
		// Act
		target.presentApod(response: response)
		
		// Assert
		XCTAssertEqual(mockOutput.apodViewModel?.title, title)
	}
	
	func test_presentApod_viewModelContainsFormatedDate() {
		// Arrange
		let date = makeDate(year: 2016, month: 07, day: 18)
		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: date, explanation: "", copyright: "")
		let response = ApodResponse(apodData: apodData)
		
		// Act
		target.presentApod(response: response)
		
		// Assert
		XCTAssertEqual(mockOutput.apodViewModel?.date, "2016年07月18日")
	}
	
	func test_presentApod_viewModelContainsExplaination() {
		// Arrange
		let explanation = "explanation"
		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: Date(), explanation: explanation, copyright: "")
		let response = ApodResponse(apodData: apodData)
		
		// Act
		target.presentApod(response: response)
		
		// Assert
		XCTAssertEqual(mockOutput.apodViewModel?.explanation, explanation)
	}
	
	func test_presentApod_viewModelContainsCopyright() {
		// Arrange
		let copyright = "copyright"
		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "http://www.google.com")!, date: Date(), explanation: "", copyright: copyright)
		let response = ApodResponse(apodData: apodData)
		
		// Act
		target.presentApod(response: response)
		
		// Assert
		XCTAssertEqual(mockOutput.apodViewModel?.copyright, copyright)
	}
	
//	func test_presentApod_displayImageIsCalled() {
//		// Arrange
//		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: URL(string: "")!, date: Date(), explanation: "", copyright: "")
//		let response = ApodResponse(apodData: apodData)
//		
//		// Act
//		target.presentApod(response: response)
//		
//		// Assert
//		XCTAssertTrue(mockOutput.displayImageCalled)
//	}
//	
//	func test_presentApod_viewModelContainsUIImage() {
//		// Arrange
//		let url = URL(string: "http://apod.nasa.gov/apod/image/1607/NGC2736NBbicolor_1250_Jurasevich1024c.jpg")!
//		let apodData = ApodData(title: "", url: URL(string: "http://www.google.com")!, hdUrl: url, date: Date(), explanation: "", copyright: "")
//		let response = ApodResponse(apodData: apodData)
//		
//		// Act
//		target.presentApod(response: response)
//		
//		// Assert
//		XCTAssertNotNil(mockOutput.imageViewModel?.picture)
//	}
	
	func test_presentError_DisplayApodErrorCalled() {
		// Arrange
		var userInfo = [NSObject: AnyObject]()
		userInfo[NSLocalizedDescriptionKey] = "Error"
		let error = NSError(domain: "World", code: 200, userInfo: userInfo)
		
		let response = ApodErrorResponse(error: error)
		
		// Act
		target.presentError(response: response)
		
		// Assert
		XCTAssertTrue(mockOutput.displayApodErrorCalled)
	}
	
	func test_presentError_ViewModelContainsLocalizedDescription() {
		// Arrange
		let errorMessage = "Error"
		var userInfo = [NSObject: AnyObject]()
		userInfo[NSLocalizedDescriptionKey] = errorMessage
		let error = NSError(domain: "World", code: 200, userInfo: userInfo)
		
		let response = ApodErrorResponse(error: error)
		
		// Act
		target.presentError(response: response)
		
		// Assert
		XCTAssertEqual(mockOutput.errorViewModel?.errorMessage, errorMessage)
	}
}
