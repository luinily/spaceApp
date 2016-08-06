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
		func downolad(url: URL, progressHandler: (progressRatio: Double) -> Void, completionHandler: (picture: UIImage?, error: NSError?) -> Void) {
			downloadCalled = true
			
		}
	}
}

// MARK: Tests
extension PictureDownloadWorkerTests {
	func test_download_callsDownloaderDownload() {
		// Arrange
		
		// Act
		target.download(URL(string: ""), progressHandler: {_ in}, completionHandler {_, _ in})
		
		// Assert
		XCTAssertTrue(downloader.downloadCalled)
	}
}
