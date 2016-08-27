//
//  NetworkTool.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (Data?, Error?) -> Void

protocol NetworkTool {
	func makeGetRequest(url: URL, parameters: [String: String], completionHandler: RequestCompletionHandler)
}
