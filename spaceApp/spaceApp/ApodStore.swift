//
//  ApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

typealias ApodCompletionHandler = (ApodData?, NSError?) -> Void

protocol ApodStore {
	func fetchTodaysPicture(completionHandler: ApodCompletionHandler)
	func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler)
	func fetchPictureForRandomDate(completionHandler: ApodCompletionHandler)
}
