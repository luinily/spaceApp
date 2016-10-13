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
	var mockPictureDownloadWorker: MockPictureDownloaderWorker!
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
		mockPictureDownloadWorker = MockPictureDownloaderWorker()
		target = ApodInteractor(apodWorker: mochApodWorker, pictureDownloadWorker: mockPictureDownloadWorker)

		mochOutput = MockOutput()
		target.output = mochOutput
	}
}

// MARK: Test doubles
extension ApodInteractorTests {
	class MockApodStore: ApodStore {
		func fetchPictureFor(date: Date, completionHandler: @escaping ApodCompletionHandler) {

		}

		func fetchTodaysPicture(completionHandler: @escaping ApodCompletionHandler) {

		}

		func fetchPictureForRandomDate(completionHandler: @escaping ApodCompletionHandler) {

		}
	}

	class MockApodWorker: ApodWorker {
		var fetchTodayApodCalled = false
		var fetchRandomApodCalled = false

		var shouldReturnData = true
		var shouldReturnHdUrl = true
		init() {
			super.init(apodStore: MockApodStore())
		}

		override func fetchTodayAPOD(completionHandler: @escaping (ApodData?, Error?) -> Void) {
			fetchTodayApodCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}

		override func fetchRandomApod(completionHandler: @escaping (ApodData?, Error?) -> Void) {
			fetchRandomApodCalled = true
			handleCompletionHandler(completionHandler: completionHandler)
		}

		private func handleCompletionHandler(completionHandler: (ApodData?, Error?) -> Void) {
			if shouldReturnData {
				if shouldReturnHdUrl {
					let apodData = ApodData(title: "", url: URL(string: "http://www.url.com")!, hdUrl: URL(string: "http://www.hdurl.com")!, date: Date(), explanation: "", copyright: "")
					completionHandler(apodData, nil)
				} else {
					let apodData = ApodData(title: "", url: URL(string: "http://www.url.com")!, hdUrl: nil, date: Date(), explanation: "", copyright: "")
					completionHandler(apodData, nil)
				}
			} else {
				let error = DownloadError.invalidData
				completionHandler(nil, error)
			}
		}
	}

	class MockPictureDownloader: PictureDownloader {
		func download(url: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (UIImage?, Error?) -> Void) {

		}

		func cancelCurrentDownload() {

		}
	}

	class MockPictureDownloaderWorker: PictureDownloadWorker {
		var downloadCalled = false
		var url: URL?
		var progressHandler: ((Double) -> Void)!
		var completionHandler: ((UIImage?, Error?) -> Void)!

		init() {
			super.init(downloader: MockPictureDownloader())
		}

		override func downolad(url: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (UIImage?, Error?) -> Void) {
			downloadCalled = true
			self.url = url
			self.progressHandler = progressHandler
			self.completionHandler = completionHandler
		}
	}

	class MockOutput: ApodInteractorOutput {
		var presentOutputCalled = false
		var presentErrorCalled = false
		var presentPictureDownloadProgressCalled = false
		var downloadProgressRatio = 0.0
		var presentPictureCalled = false

		func presentApod(response: ApodResponse) {
			presentOutputCalled = true
		}

		func presentError(response: ApodErrorResponse) {
			presentErrorCalled = true
		}

		func presentPictureDownloadProgress(response: ApodPictureDownloadProgressResponse) {
			presentPictureDownloadProgressCalled = true
			downloadProgressRatio = response.progressRatio
		}

		func presentPicture(response: ApodPictureResponse) {
			presentPictureCalled = true
		}
	}
}

// MARK: Tests
extension ApodInteractorTests {
    func test_failingTest() {
        XCTAssert(false)
    }
    
	// MARK: fetchTodayApod
	func test_fetchTodayApod_callsApodWorkerFetchTodayApod() {
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

	// MARK: pictureDownload
	func test_fetchTodayApod_callPictureDownloadsWorkerDownload() {
		// Arrange
		let request = TodayApodRequest()

		// Act
		target.fetchTodayApod(request: request)

		// Assert
		XCTAssertTrue(mockPictureDownloadWorker.downloadCalled)
	}

	func test_fetchTodayApod_usesHdUrlWhenThereIsOne() {
		// Arrange
		let request = TodayApodRequest()
		let url = URL(string: "http://www.hdurl.com")!

		mochApodWorker.shouldReturnHdUrl = true

		// Act
		target.fetchTodayApod(request: request)

		// Assert
		XCTAssertEqual(mockPictureDownloadWorker.url, url)
	}

	func test_fetchTodayApod_usesURLWhenThereIsNoHdUrl() {
		// Arrange
		let request = TodayApodRequest()
		let url = URL(string: "http://www.url.com")!

		mochApodWorker.shouldReturnHdUrl = false

		// Act
		target.fetchTodayApod(request: request)

		// Assert
		XCTAssertEqual(mockPictureDownloadWorker.url, url)
	}

	func test_fetchTodayApod_pictureDownload_progressHandlerCallsOutputPresentImageDownloadProgress() {
		// Arrange
		let request = TodayApodRequest()

		// Act
		target.fetchTodayApod(request: request)
		mockPictureDownloadWorker.progressHandler(0.5)

		// Assert
		XCTAssertTrue(mochOutput.presentPictureDownloadProgressCalled)
	}

	func test_fetchTodayApod_pictureDownload_outputGetsProgressRatio() {
		// Arrange
		let request = TodayApodRequest()
		let progressRatio = 0.543

		// Act
		target.fetchTodayApod(request: request)
		mockPictureDownloadWorker.progressHandler(progressRatio)

		// Assert
		XCTAssertEqual(mochOutput.downloadProgressRatio, progressRatio)
	}

	func test_fetchTodayApod_pictureDownload_completionHandlerCallsOutputPresentPicture() {
		// Arrange
		let request = TodayApodRequest()

		// Act
		target.fetchTodayApod(request: request)
		mockPictureDownloadWorker.completionHandler(UIImage(), nil)

		// Assert
		XCTAssertTrue(mochOutput.presentPictureCalled)
	}

	func test_fetchTodayApod_pictureDownload_completionHandlerCallsOutputPresentError() {
		// Arrange
		let request = TodayApodRequest()
		let error = DownloadError.invalidData

		// Act
		target.fetchTodayApod(request: request)
		mockPictureDownloadWorker.completionHandler(nil, error)

		// Assert
		XCTAssertTrue(mochOutput.presentErrorCalled)
	}


	// MARK: fetchRandomApod
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
