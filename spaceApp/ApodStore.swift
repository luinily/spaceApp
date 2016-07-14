//
//  ApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol ApodStore {
	associatedtype ApodCompletionHandler = (pictureData: Data?, error: NSError?) -> Void
	
	func fetchTodaysPicture(completionHandler: ApodCompletionHandler)
	func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler)
	func fetchHDPictureFor(date: Date, completionHandler: ApodCompletionHandler)
}
