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
	func makeGetRequest(url: URL,
	                    parameters: [String: String],
	                    completionHandler: @escaping RequestCompletionHandler) {
		let request = Alamofire.request(url, method: .get, parameters: parameters)

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

	private func alamofireParameters(parameters: [String: String]) -> Parameters? {
		var result = Parameters()
		for key in parameters.keys {
			result[key] = parameters[key]
		}
		return result
	}

}
