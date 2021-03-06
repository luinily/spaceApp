//
//  ApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

typealias ApodCompletionHandler = (ApodData?, Error?) -> Void

protocol ApodStore {
	func fetchTodaysPicture(completionHandler: @escaping ApodCompletionHandler)
	func fetchPictureFor(date: Date, completionHandler: @escaping ApodCompletionHandler)
	func fetchPictureForRandomDate(completionHandler: @escaping ApodCompletionHandler)
}
