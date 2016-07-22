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
		let date = makeRamdomDate()
		let parameters = makeParameters(date: date)
		_networkTool.makeGetRequest(url: _requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data, error: error, completionHandler: completionHandler)
		}
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
	
	private func makeRamdomDate() -> Date {
		let today = Date()
		
		var components = DateComponents()
		components.year = makeRamdomComponent(unit: .year, lowerBoundDate: _oldestDatePossible, higherBoundDate: today)
		components.month = makeRandomNumber(lowerBound: 0, higherBound: 12)
		components.day = makeRandomDay(components: components)
		components.hour = 0
		components.minute = 0
		
		if let date = Calendar.current.date(from: components) {
			return date
		}
		return today
	}
	
	private func makeRamdomComponent(unit: Calendar.Unit, lowerBoundDate: Date, higherBoundDate: Date) -> Int {
		let lowerBoundComponent = Calendar.current.component(unit, from: lowerBoundDate)
		let higherBoundComponent = Calendar.current.component(unit, from: higherBoundDate)
		return makeRandomNumber(lowerBound: lowerBoundComponent, higherBound: higherBoundComponent)
	}
	
	private func makeRandomDay(components: DateComponents) -> Int {
		if let date = Calendar.current.date(from: components) {
			let range = Calendar.current.range(of: .day, in: .month, for: date)
			return makeRandomNumber(lowerBound: 1, higherBound: range.length)
		}
		return 28 //will not give any invalid day
	}

	private func makeRandomNumber(lowerBound: Int, higherBound: Int) -> Int {
		let upperBound = higherBound - lowerBound
		let randomNumber = Int(arc4random_uniform(UInt32(upperBound)))
		return randomNumber + lowerBound
	}
}
