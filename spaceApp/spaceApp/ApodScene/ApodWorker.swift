//
//  ApodWorker.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class ApodWorker {
	private var _apodStore: ApodStore
	// MARK: Business Logic
	
	init(apodStore: ApodStore) {
		_apodStore = apodStore
	}
	
	func fetchTodayAPOD(completionHandler: (apodData: ApodData?, error: NSError?) -> Void) {
		// NOTE: Do the work
		_apodStore.fetchTodaysPicture() {
			data, error in
			completionHandler(apodData: data, error: error)
		}
	}
	
	func fetchRandomApod(completionHandler: (apodData: ApodData?, error: NSError?) -> Void) {
		_apodStore.fetchPictureForRandomDate() {
			data, error in
			completionHandler(apodData: data, error: error)
		}
	}
}
