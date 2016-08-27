//
//  AlamofireTool.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireTool: NetworkTool {
	func makeGetRequest(url: URL, parameters: [String: String], completionHandler: RequestCompletionHandler) {
		let request = Alamofire.request(url.urlString, withMethod: .get, parameters: parameters, encoding: .url)
		let validatedRequest = request.validate()
		validatedRequest.responseJSON {
			response in
			if response.result.isSuccess {
				completionHandler(response.data, nil)
			} else {
				print(response.result.error?.localizedDescription)
				print(response.request.debugDescription)
				completionHandler(nil, response.result.error)
			}
		}
	}

}
