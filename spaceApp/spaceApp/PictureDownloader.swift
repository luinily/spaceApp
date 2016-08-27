//
//  PictureDownloader.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/08/01.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import UIKit

protocol PictureDownloader {
	func download(url: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (UIImage?, NSError?) -> Void)
	
	func cancelCurrentDownload()
}
