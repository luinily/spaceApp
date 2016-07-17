//
//  ApodInitializer.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct ApodInitializer: Initializer {
	private let apodRequestURL = "https://api.nasa.gov/planetary/apod"
	private let apodApiKey = "ooZOv9QcCFLU8kOE9rKJlEx9TtdOhaT4oo9smEx3"
	
	func createApodNetworkTool() -> NetworkTool {
		return AlamofireTool()
	}
	
	func createDataToApodConverter() -> DataToApodDataConverter {
		return JsonToApodConvertor()
	}
	
	func createApodStore() -> ApodStore {
		let networkTool = createApodNetworkTool()
		let dataConvertor = createDataToApodConverter()
		
		return NetworkApodStore(requestURL: apodRequestURL, apiKey: apodApiKey, networkTool: networkTool, dataConvertor: dataConvertor)!
	}
}
