//
//  NetworkApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct NetworkApodStore {
	private let _requestURL: URL //"https://api.nasa.gov/planetary/apod"
	private let _apiKey: String //"ooZOv9QcCFLU8kOE9rKJlEx9TtdOhaT4oo9smEx3"
	private let _networkTool: NetworkTool
	private let _dataConvertor: DataToApodDataConverter
	
	init?(requestURL: String, apiKey: String, networkTool: NetworkTool, dataConvertor: DataToApodDataConverter) {
		guard let url = URL(string: requestURL) else {
			return nil
		}
		
		_requestURL = url
		_apiKey = apiKey
		_networkTool = networkTool
		_dataConvertor = dataConvertor
	}
}

extension NetworkApodStore: ApodStore {
	func fetchTodaysPicture(completionHandler: ApodCompletionHandler) {
		_networkTool.makeGetRequest(url: _requestURL, apiKey: _apiKey, parameters: [String: String]()) {
			data, error in
			
			guard error == nil else {
				completionHandler(pictureData: nil, error: error)
				return
			}
			
			guard let data = data else {
				return
			}
			
			let apodData = try? self._dataConvertor.convertDataToApodData(data: data)
			completionHandler(pictureData: apodData, error: nil)
		}
	}
	
	func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler) {
		
	}
}
