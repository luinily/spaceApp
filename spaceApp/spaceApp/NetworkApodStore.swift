//
//  NetworkApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct NetworkApodStore {
	private let _requestURL: URL
	private let _apiKeyParameterName = "api_key"
	private let _hdParameterName = "hd"
	private let _hdParameterValue = "true"
	private let _dateParameterName = "date"
	private let _dateParameterFormat = "yyyy-MM-dd"
	private let _oldestDatePossible: Date
	private let _apiKey: String 
	private let _networkTool: NetworkTool
	private let _dataConvertor: DataToApodDataConverter
	
	init?(requestURl: URL, oldestPossibleDate: Date, apiKey: String, networkTool: NetworkTool, dataConvertor: DataToApodDataConverter) {
		_requestURL = requestURl
		_oldestDatePossible = oldestPossibleDate
		_apiKey = apiKey
		_networkTool = networkTool
		_dataConvertor = dataConvertor
	}
}

extension NetworkApodStore: ApodStore {
	func fetchTodaysPicture(completionHandler: ApodCompletionHandler) {
		let parameters = makeParameters()
		
		_networkTool.makeGetRequest(url: _requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data, error: error, completionHandler: completionHandler)
		}
	}
	
	func fetchPictureFor(date: Date, completionHandler: ApodCompletionHandler) {
		let parameters = makeParameters(date: date)
		_networkTool.makeGetRequest(url: _requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data, error: error, completionHandler: completionHandler)
		}
	}
	
	func fetchPictureForRandomDate(completionHandler: ApodCompletionHandler) {
		let date = generateRandomDate()
		let parameters = makeParameters(date: date)
		_networkTool.makeGetRequest(url: _requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data, error: error, completionHandler: completionHandler)
		}
	}
	
	private func generateRandomDate() -> Date {
		let today = Date()
		let randomDateGenerator = RandomDateGenerator(lowerBound: _oldestDatePossible, higherBound: today)
		return randomDateGenerator.generateDate()
	}
	
	private func makeParameters(date: Date? = nil) -> [String: String] {
		var parameters = [String: String]()
		parameters[_apiKeyParameterName] = _apiKey
		parameters[_hdParameterName] = _hdParameterValue
		if let date = date {
			parameters[_dateParameterName] = makeDateParameter(date: date)
		}
		
		return parameters
	}
	
	private func makeDateParameter(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = _dateParameterFormat
		return formatter.string(from: date)
	}
	
	private func handleFetchedResults(data: Data?, error: NSError?, completionHandler: ApodCompletionHandler) {
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
