//
//  DataToApodDataConverter.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/15.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

protocol DataToApodDataConverter {
	func convertDataToApodData(data: Data) throws -> ApodData
}
