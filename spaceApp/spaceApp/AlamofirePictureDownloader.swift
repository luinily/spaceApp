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

class AlamofirePictureDownloader: PictureDownloader {
	func download(url: URL, progressHandler: (progressRatio: Double) -> Void, completionHandler: (picture: UIImage?, error: NSError?) -> Void) {
		download(url: url) {
			progressRatio, fileURL, error in
			if let progressRatio = progressRatio {
				progressHandler(progressRatio: progressRatio)
			} else if let error = error {
				completionHandler(picture: nil, error: error)
			} else if let url = fileURL {
				if let data = try? Data(contentsOf: url) {
					completionHandler(picture: UIImage(data: data), error: nil)
				}
			}
		}
	}
	
	private func download(url: URL, completionHandler: (progressRatio: Double?, fileURL: URL?, error: NSError?) -> Void) {
		
		var didCancel = false
		
		let request = Alamofire.download(.GET, url.urlString, destination: getFileDestination)
		
		request.progress() {
			bytesRead, totalBytesRead, totalBytesExpectedToRead in
			
			guard totalBytesExpectedToRead > 0 else {
				request.cancel()
				didCancel = true
				return
			}
			
			DispatchQueue.main.async {
				let ratio = max(Double(totalBytesRead) / Double(totalBytesExpectedToRead), 0)
				completionHandler(progressRatio: ratio, fileURL: nil, error: nil)
			}
		}
		
		request.response() {
			_, response, _, error in
			if didCancel {
				let error = self.makeCancelError()
				completionHandler(progressRatio: nil, fileURL: nil, error: error)
			} else if let error = error {
				print("Failed with error: \(error)")
				completionHandler(progressRatio: nil, fileURL: nil, error: error)
			} else if let response = response {
				let fileURL = self.getFileURL(from: response)
				completionHandler(progressRatio: nil, fileURL: fileURL, error: nil)
			}
		}
	}
	
	
	private func makeCancelError() -> NSError {
		var userInfo = [NSObject: AnyObject]()
		userInfo[NSLocalizedDescriptionKey] = "Invalid Data"
		
		let error = NSError(domain: "World", code: 200, userInfo: userInfo)
		return error
	}
	
	private func getFileDestination(temporaryURL: URL, response: HTTPURLResponse) -> URL {
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

		let fileName = "ApodPicture.jpg"
		
		let finalPath = directoryURL.appendingPathComponent(fileName)
	
		if FileManager.default.fileExists(atPath: finalPath.path) {
			try? FileManager.default.removeItem(atPath: finalPath.path)
		}
		
		return finalPath
	}
	
	private func getFileURL(from response: HTTPURLResponse) -> URL {
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let fileName = "ApodPicture.jpg"
		return directoryURL.appendingPathComponent(fileName)
	}
}
