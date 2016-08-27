//
//  PictureDownloadWorkerTests.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/08/04.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import XCTest
@testable import spaceApp

class PictureDownloadWorkerTests: XCTestCase {
	// MARK: Subject under test
	var target: PictureDownloadWorker!
	var downloader: MockPictureDownloadWorker!
}

// MARK: Test lifecycle
extension PictureDownloadWorkerTests {
	override func setUp() {
		downloader = MockPictureDownloadWorker()
		target = PictureDownloadWorker(downloader: downloader)
	}
	
	override func tearDown() {
		
	}
}

// MARK: Test setup
extension PictureDownloadWorkerTests {
	
}

// MARK: Test doubles
extension PictureDownloadWorkerTests {
	class MockPictureDownloadWorker: PictureDownloader {
		var downloadCalled = false
		var url: URL?
		var progressRatio = 1.0
		
		var cancelCurrentDownloadCalled = false
		
		func download(url: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (UIImage?, NSError?) -> Void) {
			downloadCalled = true
			self.url = url
			progressHandler(progressRatio)
			completionHandler(nil, nil)
		}
		
		func cancelCurrentDownload() {
			cancelCurrentDownloadCalled = true
		}
	}
}

// MARK: Tests
extension PictureDownloadWorkerTests {
	func test_download_callsDonwloaderCancelCurrentDonwload() {
		// Arrange
		
		// Act
		target.downolad(url: URL(string: "http://www.test.com")!, progressHandler: {_ in}, completionHandler: {_, _ in})
		
		// Assert
		XCTAssertTrue(downloader.cancelCurrentDownloadCalled)
	}
	
	func test_download_callsDownloaderDownload() {
		// Arrange
		
		// Act
		target.downolad(url: URL(string: "http://www.test.com")!, progressHandler: {_ in}, completionHandler: {_, _ in})
		
		// Assert
		XCTAssertTrue(downloader.downloadCalled)
	}
	
	func test_download_passesURL() {
		// Arrange
		let url = URL(string: "http://www.test.com")!
		
		// Act
		target.downolad(url: url, progressHandler: {_ in}, completionHandler: {_, _ in})
		
		// Assert
		XCTAssertEqual(url, downloader.url)
	}

	func test_download_passesProgressHandler() {
		// Arrange
		var progressHandlerCalled = false
		// Act
		target.downolad(url: URL(string: "http://www.test.com")!,
		                progressHandler: {
							_ in
							progressHandlerCalled = true
						},
		                completionHandler: {_, _ in}
		)
		
		// Assert
		XCTAssertTrue(progressHandlerCalled)
	}
	
	func test_download_passesCompletionHandler() {
		// Arrange
		var completionHandlerCalled = false
		// Act
		target.downolad(url: URL(string: "http://www.test.com")!,
		                progressHandler: { _ in },
		                completionHandler: {
							_, _ in
							completionHandlerCalled = true
						}
		)
		
		// Assert
		XCTAssertTrue(completionHandlerCalled)
	}
}
