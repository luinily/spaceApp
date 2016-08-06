//
//  ApodInitializer.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct ApodInitializer: Initializer {
	private let apodURL = "https://api.nasa.gov/planetary/apod"
	private let oldestDate = (year: 1995, month: 06, day: 16)
	private let nasaApiKey = "ooZOv9QcCFLU8kOE9rKJlEx9TtdOhaT4oo9smEx3"
	
	func createApodNetworkTool() -> NetworkTool {
		return AlamofireTool()
	}
	
	func createDataToApodConverter() -> DataToApodDataConverter {
		return JsonToApodConvertor()
	}
	
	func createApodStore() -> ApodStore {
		let networkTool = createApodNetworkTool()
		let dataConvertor = createDataToApodConverter()
		let requestURL = URL(string: apodURL)!
		let date = makeDate(date: oldestDate)
		return NetworkApodStore(requestURl: requestURL, oldestPossibleDate: date, apiKey: nasaApiKey, networkTool: networkTool, dataConvertor: dataConvertor)!
	}
	
	private func makeDate(date: (year: Int, month: Int, day: Int)) -> Date {
		var components = DateComponents()
		components.year = date.year
		components.month = date.month
		components.day = date.day
		components.hour = 0
		components.minute = 0
		return Calendar.current.date(from: components)!
	}
	
	func createPictureDownloader() -> PictureDownloader {
		return AlamofirePictureDownloader()
	}
}
