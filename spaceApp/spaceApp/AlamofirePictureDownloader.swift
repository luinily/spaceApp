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
	func downolad(url: URL, progressHandler: (progressRatio: Double) -> Void, completionHandler: (picture: UIImage?, error: NSError?) -> Void) {
		download(url: url) {
			progressRatio, fileURL, error in
			if let progressRatio = progressRatio {
				progressHandler(progressRatio: progressRatio)
				if let url = fileURL {
					if let data = try? Data(contentsOf: url) {
						completionHandler(picture: UIImage(data: data), error: nil)
					}
				}
			} else if let error = error {
				completionHandler(picture: nil, error: error)
			}
		}
	}
	
	private func download(url: URL, completionHandler: (progressRatio: Double?, fileURL: URL?, error: NSError?) -> Void) {
		
		let destination = Alamofire.Request.suggestedDownloadDestination(
			directory: .cachesDirectory,
			domain: .userDomainMask
		)
		
		Alamofire.download(.GET, url.absoluteString, destination: destination).progress {
			bytesRead, totalBytesRead, totalBytesExpectedToRead in
			
			DispatchQueue.main.async {
				let ratio = Double(totalBytesRead) / Double(totalBytesExpectedToRead)
				completionHandler(progressRatio: ratio, fileURL: nil, error: nil)
			}
			}.response {
				_, response, _, error in
				if let error = error {
					print("Failed with error: \(error)")
					completionHandler(progressRatio: nil, fileURL: nil, error: error)
				} else if let response = response {
					let fileURL = destination(URL(string: "")!, response)
					completionHandler(progressRatio: nil, fileURL: fileURL, error: nil)
				}
		}
		
		
	}
}
