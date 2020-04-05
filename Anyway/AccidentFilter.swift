//
//  AccidentFilter.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/04/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//

import Foundation

enum Weekday: Int {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, all
}

enum Weather: Int {
    case all, clear, rainy, torrid, cloudy, other
}

enum TimeOfDay: Int {
    case all = 24, light = 25, dark = 26, morning = 6, noon = 12, evening = 18, night = 0
}

enum Occasion: Int {
    case all, holiday, holidayEve, intermediate, weekday
}

enum Severity {
    case light, severe, fatal, all
}

enum StreetDirection {
    case oneWay, twoWay, all
}


struct AccidentFilter {
    var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    var endDate = Date() // Default: Now

    var severity = Severity.all
    var street = StreetDirection.all
    var weekday = Weekday.all
    var occasion = Occasion.all
    var timeOfDay = TimeOfDay.all
    var weather = Weather.all

    var accurate: Bool? = nil
    var urban: Bool? = nil
    var intersection: Bool? = nil
}
