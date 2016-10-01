//
//  AlamofirePictureDownloader.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/31.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


enum DownloadError: LocalizedError {
	case invalidData

	var errorDescription: String? {
		switch self {
		case .invalidData: return NSLocalizedString("Invalid Data", comment: "")
		}
	}
}

class AlamofirePictureDownloader: PictureDownloader {
	private var currentRequest: DownloadRequest?

	func download(url: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (UIImage?, Error?) -> Void) {
		download(url: url) {
			progressRatio, fileURL, error in
			if let progressRatio = progressRatio {
				progressHandler(progressRatio)
			} else if let error = error {
				completionHandler(nil, error)
			} else if let url = fileURL {
				if let data = try? Data(contentsOf: url) {
					completionHandler(UIImage(data: data), nil)
				}
			}
		}
	}

	func cancelCurrentDownload() {
		currentRequest?.cancel()
	}

	private func download(url: URL, completionHandler: @escaping (Double?, URL?, Error?) -> Void) {


		currentRequest = Alamofire.download(url, to: getFileDestination)

		currentRequest?.downloadProgress() {
			progress in
			DispatchQueue.main.async {
				completionHandler(progress.fractionCompleted, nil, nil)
			}
		}

		currentRequest?.responseData() {
			response in

			if let error = response.result.error {
				print("Failed with error: \(error)")
				completionHandler(nil, nil, error)
			} else if let response = response.response {
				let fileURL = self.getFileURL(from: response)
				completionHandler(nil, fileURL, nil)
			}
		}
	}


	private func makeCancelError() -> Error {
		return DownloadError.invalidData
	}

	private func getFileDestination(temporaryURL: URL,
	                                response: HTTPURLResponse) ->
		(destinationURL: URL, options: DownloadRequest.DownloadOptions) {
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

		let fileName = "ApodPicture.jpg"

		let finalPath = directoryURL.appendingPathComponent(fileName)

		if FileManager.default.fileExists(atPath: finalPath.path) {
			try? FileManager.default.removeItem(atPath: finalPath.path)
		}

			return (destinationURL: finalPath, options: .removePreviousFile)
	}

	private func getFileURL(from response: HTTPURLResponse) -> URL {
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let fileName = "ApodPicture.jpg"
		return directoryURL.appendingPathComponent(fileName)
	}
}
