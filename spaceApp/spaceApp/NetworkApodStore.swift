//
//  NetworkApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct NetworkApodStore {
	private let _requestURL = "https://api.nasa.gov/planetary/apod"
	private let _networkTool: NetworkTool
	
	init(networkTool: NetworkTool) {
		_networkTool = networkTool
	}
}

extension NetworkApodStore: ApodStore {
	func fetchTodaysPicture(completionHandler: ApodCompletionHandler) {
		_networkTool.makeGetRequest(url: _requestURL, parameters: [String: String]()) {
			_,_ in
		}
	}
	
	func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler) {
		
	}
}
