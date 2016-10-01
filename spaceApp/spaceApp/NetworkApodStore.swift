//
//  NetworkApodStore.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct NetworkApodStore {
	fileprivate let requestURL: URL
	fileprivate let apiKeyParameterName = "api_key"
	fileprivate let hdParameterName = "hd"
	fileprivate let hdParameterValue = "true"
	fileprivate let dateParameterName = "date"
	fileprivate let dateParameterFormat = "yyyy-MM-dd"
	fileprivate let oldestDatePossible: Date
	fileprivate let apiKey: String
	fileprivate let networkTool: NetworkTool
	fileprivate let dataConvertor: DataToApodDataConverter

	init?(requestURl: URL,
	      oldestPossibleDate: Date,
	      apiKey: String,
	      networkTool: NetworkTool,
	      dataConvertor: DataToApodDataConverter) {
		self.requestURL = requestURl
		self.oldestDatePossible = oldestPossibleDate
		self.apiKey = apiKey
		self.networkTool = networkTool
		self.dataConvertor = dataConvertor
	}
}

extension NetworkApodStore: ApodStore {
	func fetchTodaysPicture(completionHandler: @escaping ApodCompletionHandler) {
		let parameters = makeParameters()

		networkTool.makeGetRequest(url: requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data, error: error, completionHandler: completionHandler)
		}
	}

	func fetchPictureFor(date: Date, completionHandler: @escaping ApodCompletionHandler) {
		let parameters = makeParameters(date: date)
		networkTool.makeGetRequest(url: requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data,
			                          error: error,
			                          completionHandler: completionHandler)
		}
	}

	func fetchPictureForRandomDate(completionHandler: @escaping ApodCompletionHandler) {
		let date = generateRandomDate()
		let parameters = makeParameters(date: date)
		networkTool.makeGetRequest(url: requestURL, parameters: parameters) {
			data, error in
			self.handleFetchedResults(data: data,
			                          error: error,
			                          completionHandler: completionHandler)
		}
	}

	private func generateRandomDate() -> Date {
		let today = Date()
		let randomDateGenerator = RandomDateGenerator(lowerBound: oldestDatePossible,
		                                              higherBound: today)
		return randomDateGenerator.generateDate()
	}

	private func makeParameters(date: Date? = nil) -> [String: String] {
		var parameters = [String: String]()
		parameters[apiKeyParameterName] = apiKey
		parameters[hdParameterName] = hdParameterValue
		if let date = date {
			parameters[dateParameterName] = makeDateParameter(date: date)
		}

		return parameters
	}

	private func makeDateParameter(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = dateParameterFormat
		return formatter.string(from: date)
	}

	private func handleFetchedResults(data: Data?,
	                                  error: Error?,
	                                  completionHandler: ApodCompletionHandler) {
		guard error == nil else {
			completionHandler(nil, error)
			return
		}

		guard let data = data else {
			return
		}

		let apodData = try? self.dataConvertor.convertDataToApodData(data: data)
		completionHandler(apodData, nil)
	}




}
