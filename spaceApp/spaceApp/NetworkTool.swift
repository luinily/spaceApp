//
//  NetworkTool.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (data: Data?, error: NSError?) -> Void

protocol NetworkTool {
	func makeGetRequest(url: URL, apiKey: String, parameters: [String: String], completionHandler: RequestCompletionHandler)
}
