//
//  Initializer.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol Initializer {
	func createApodNetworkTool() -> NetworkTool
	func createDataToApodConverter() -> DataToApodDataConverter
	func createApodStore() -> ApodStore
}
