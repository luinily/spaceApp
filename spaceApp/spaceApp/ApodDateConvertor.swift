//
//  ApodDateConvertor.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/16.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct ApodDateConvertor {
	private let stringLength = 10
	private let yearStartOffset = 4
	private let monthStartOffset = 5
	private let monthEndOffset = 7
	private let dayStartOffset = 8
	private let january = 1
	private let december = 12
	
	func dateFromString(dateString: String) -> Date? {
		guard dateString.characters.count == stringLength else {
			return nil
		}
		
		guard let components = extractDateComponentsFromString(dateString: dateString) else {
			return nil
		}
		
		return Calendar.current.date(from: components)
	}
	
	private func extractDateComponentsFromString(dateString: String) -> DateComponents? {
		guard let year = getYearFromString(dateString: dateString) else {
			return nil
		}
		
		guard let month = getMonthFromString(dateString: dateString), (month >= january && month <= december) else {
			return nil
		}

		guard let day = getDayFromString(dateString: dateString) else {
			return nil
		}
		
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = 0
		components.minute = 0
		return components
	}
	
	private func getYearFromString(dateString: String) -> Int? {
		let yearEndIndex = dateString.index(dateString.startIndex, offsetBy: yearStartOffset)
		let yearString = dateString.substring(to: yearEndIndex)
		return Int(yearString)
	}
	
	private func getMonthFromString(dateString: String) -> Int? {
		let monthStart = dateString.index(dateString.startIndex, offsetBy: monthStartOffset)
		let monthEnd = dateString.index(dateString.startIndex, offsetBy: monthEndOffset)
		let monthRange = Range(uncheckedBounds: (lower: monthStart, upper: monthEnd))
		
		let monthString = dateString.substring(with: monthRange)
		
		return Int(monthString)
	}
	
	private func getDayFromString(dateString: String) -> Int? {
		let dayStart = dateString.index(dateString.startIndex, offsetBy: dayStartOffset)
		let dayString = dateString.substring(from: dayStart)
		
		return Int(dayString)
	}
}
