//
//  ApodModels.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct TodayApodRequest {
}

struct ApodResponse {
	var apodData: ApodData
}

struct ApodErrorResponse {
	var error: NSError
}

struct ApodViewModel {
	var title: String
	var picture: UIImage?
	var date: String
	var explanation: String
	var copyright: String
}
