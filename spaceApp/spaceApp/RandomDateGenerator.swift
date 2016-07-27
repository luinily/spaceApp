//
//  RandomDateGenerator.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/27.
//  Copyright © 2016年 YoannColdefy. All rights reserved.
//

import Foundation

struct RandomDateGenerator {
	let lowerBound: Date
	let higherBound: Date
	
	func generateDate() -> Date {		
		let year = makeRandomYear()
		let month = makeRandomMonth(year: year)
		let day = makeRandomDay(forMonth: month, ofYear: year)
		
		if let date = makeDate(year: year, month: month, day: day) {
			return date
		} else {
			return higherBound
		}
	}
	
	private func makeRandomYear() -> Int {
		let lowerBound = Calendar.current.component(.year, from: self.lowerBound)
		let higherBound = Calendar.current.component(.year, from: self.higherBound)
		return makeRandomNumber(lowerBound: lowerBound, higherBound: higherBound)
	}
	
	private func makeRandomMonth(year: Int) -> Int {
		let lowerBound = getLowerBoundMonth(forYear: year)
		let higherBound = getHigherBoundMonth(forYear: year)
		
		return makeRandomNumber(lowerBound: lowerBound, higherBound: higherBound)
	}
	
	private func getLowerBoundMonth(forYear year: Int) -> Int {
		if isLowerBound(unit: .year, value: year) {
			return Calendar.current.component(.month, from: self.lowerBound)
		} else {
			return 1
		}
	}
	
	private func getHigherBoundMonth(forYear year: Int) -> Int {
		if isHigherBound(unit: .year, value: year) {
			return Calendar.current.component(.month, from: self.higherBound)
		} else {
			return 12
		}
	}
	
	private func makeRandomDay(forMonth month: Int, ofYear year: Int) -> Int {
		let lowerBound = getLowerBoundDay(forMonth: month)
		let higherBound = getHigherBoundDay(forMonth: month, ofYear: year)
		
		return makeRandomNumber(lowerBound: lowerBound, higherBound: higherBound)
	}
	
	private func getLowerBoundDay(forMonth month: Int) -> Int {
		if isLowerBound(unit: .month, value: month) {
			return Calendar.current.component(.month, from: self.lowerBound)
		} else {
			return 1
		}
	}
	
	private func getHigherBoundDay(forMonth month: Int, ofYear year: Int) -> Int {
		if isHigherBound(unit: .month, value: month) {
			return Calendar.current.component(.day, from: self.higherBound)
		} else {
			if let date = makeDate(year: year, month: month, day: 1) {
				let range = Calendar.current.range(of: .day, in: .month, for: date)
				return range.length
			} else {
				return 28
			}
		}
		
	}
	private func isLowerBound(unit: Calendar.Unit, value: Int) -> Bool {
		let higherBound = Calendar.current.component(unit, from: self.higherBound)
		return value == higherBound
	}
	
	private func isHigherBound(unit: Calendar.Unit, value: Int) -> Bool {
		let lowerBound = Calendar.current.component(unit, from: self.lowerBound)
		return value == lowerBound
	}

	
	private func makeRandomNumber(lowerBound: Int, higherBound: Int) -> Int {
		let upperBound = higherBound - lowerBound
		let randomNumber = Int(arc4random_uniform(UInt32(upperBound)))
		return randomNumber + lowerBound
	}
	
	private func makeDate(year: Int, month: Int, day: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = 0
		components.minute = 0
		
		return Calendar.current.date(from: components)
	}
}
