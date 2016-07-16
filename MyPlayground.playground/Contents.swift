//: Playground - noun: a place where people can play

import UIKit

let dateString = "2016-07-16"

let yearEnd = dateString.index(dateString.startIndex, offsetBy: 4)

let year = dateString.substring(to: yearEnd)

let monthStart = dateString.index(dateString.startIndex, offsetBy: 5)
let monthEnd = dateString.index(dateString.startIndex, offsetBy: 7)
let monthRange = Range(uncheckedBounds: (lower: monthStart, upper: monthEnd))

let month = dateString.substring(with: monthRange)

let dayStart = dateString.index(dateString.startIndex, offsetBy: 8)
let day = dateString.substring(from: dayStart)

let date = Date()
date.