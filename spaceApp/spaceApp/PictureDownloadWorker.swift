//
//  PictureDownloadWorker.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/08/04.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

class PictureDownloadWorker {
	private let _downloader: PictureDownloader
	
	init(downloader: PictureDownloader) {
		_downloader = downloader
	}
	
	func downolad(url: URL, progressHandler: (progressRatio: Double) -> Void, completionHandler: (picture: UIImage?, error: NSError?) -> Void) {
		_downloader.cancelCurrentDownload()
		_downloader.download(url: url, progressHandler: progressHandler, completionHandler: completionHandler)
	}
}
