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
	}
}

// MARK: Test doubles
extension ApodPresenterTests {
	class MockOutput: ApodPresenterOutput {
		var displayApodCalled = false
		
		func displayApod(viewModel: ApodViewModel) {
			displayApodCalled = true
		}
	}
}

// MARK: Tests
extension ApodPresenterTests {
	func test_presentApod_callsDisplayAPOD() {
		// Arrange
		
		// Act
//		target.presentApod(response: <#T##ApodResponse#>)
		// Assert
	}
}

