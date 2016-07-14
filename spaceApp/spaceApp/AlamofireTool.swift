//
//  AlamofireTool.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/14.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireTool {
	
}

extension AlamofireTool: NetworkTool {
	func makeGetRequest(url: String, parameters: [String: String], completionHandler: RequestCompletionHandler) {
		let request = Alamofire.request(.GET, url, parameters: parameters)
		let validatedRequest = request.validate()
		validatedRequest.responseJSON {
			response in
			if response.result.isSuccess {
				completionHandler(data: response.data, error: nil)
			} else {
				completionHandler(data: nil, error: response.result.error)
			}
		}
	}

}
