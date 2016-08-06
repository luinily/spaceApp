//
//  JSonToApodConvertor.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/16.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

enum JSonToApodConvertorError: Error {
	case couldNotConvertDataToJson
	case dataWasNotJsonDictionaryData
	case dateNotInJson
	case couldNotConvertDateStringToDate
	case explanationNotInJson
	case urlNotInJSon
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

		guard let normalUrl = getURL(from: json, forTag: "url") else {
			throw JSonToApodConvertorError.urlNotInJSon
		}
		
		let hdUrl = getURL(from: json, forTag: "hdurl")
		
		guard let title = json["title"] as? String else {
			throw JSonToApodConvertorError.titleNotInJson
		}
		
		return ApodData(title: title, url: normalUrl, hdUrl: hdUrl, date: date, explanation: explanation, copyright: copyright)
	}
	
	private func getURL(from json: [String: AnyObject], forTag tag: String) -> URL? {
		guard let urlString = json[tag] as? String else {
			return nil
		}
		
		return URL(string: urlString)
	}
	
}
