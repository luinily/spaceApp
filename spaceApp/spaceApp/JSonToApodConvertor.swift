//
//  JSonToApodConvertor.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/16.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum JSonToApodConvertorError: ErrorProtocol {
	case couldNotConvertDataToJson
	case dataWasNotJsonDictionaryData
	case dateNotInJson
	case couldNotConvertDateStringToDate
	case explanationNotInJson
	case hdUrlNotInJson
	case urlNotInJSon
	case canNotMakeURLFromHdUrl
	case canNotMakeURLFromUrl
	case titleNotInJson
}

struct JsonToApodConvertor: DataToApodDataConverter {
	
	func convertDataToApodData(data: Data) throws -> ApodData {
		var json: AnyObject
		do {
			json = try JSONSerialization.jsonObject(with: data, options: [])
		} catch {
			throw JSonToApodConvertorError.couldNotConvertDataToJson
		}
		
		guard let jsonDic = json as? [String: AnyObject] else {
			throw JSonToApodConvertorError.dataWasNotJsonDictionaryData
		}
		
		return try convertJsonToApod(json: jsonDic)
	}
	
	private func convertJsonToApod(json: [String: AnyObject]) throws -> ApodData {
		var copyright = ""
		if let copyrightString = json["copyright"] as? String {
			copyright = copyrightString
		}
		
		guard let dateString = json["date"] as? String else {
			throw JSonToApodConvertorError.dateNotInJson
		}
		
		guard let date = ApodDateConvertor().dateFromString(dateString: dateString) else {
			throw JSonToApodConvertorError.couldNotConvertDateStringToDate
		}

		guard let explanation = json["explanation"] as? String else {
			throw JSonToApodConvertorError.explanationNotInJson
		}

		guard let hdurlString = json["hdurl"] as? String else {
			throw JSonToApodConvertorError.hdUrlNotInJson
		}
		
		guard let hdUrl = URL(string: hdurlString) else {
			throw JSonToApodConvertorError.canNotMakeURLFromHdUrl
		}
		
		guard let title = json["title"] as? String else {
			throw JSonToApodConvertorError.titleNotInJson
		}
		
		guard let urlString = json["url"] as? String else {
			throw JSonToApodConvertorError.urlNotInJSon
		}
		
		guard let url = URL(string: urlString) else {
			throw JSonToApodConvertorError.canNotMakeURLFromUrl
		}
		
		return ApodData(title: title, url: url, hdUrl: hdUrl, date: date, explanation: explanation, copyright: copyright)
	}
	
}
