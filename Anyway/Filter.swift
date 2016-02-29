//
//  Filter.swift
//  Anyway
//
//  Created by Aviel Gross on 14/12/2015.
//  Copyright © 2015 Hasadna. All rights reserved.
//

import Foundation

struct IntersectionType {
    var showIn: Bool
    var showNot: Bool
    
    private var showInCurrentVal: Int { return showIn ? 2 : 0 }
    private var showNotCurrentVal: Int { return showNot ? 1 : 0 }
    var value: Int { return showInCurrentVal + showNotCurrentVal }
}

struct LaneType {
    var oneWay: Bool
    var bothWays: Bool
    
    private var bothWaysCurrentVal: Int { return bothWays ? 2 : 0 }
    private var oneWayCurrentVal: Int { return oneWay ? 1 : 0 }
    var value: Int { return bothWaysCurrentVal + oneWayCurrentVal }
}

struct UrbanType {
    var urban: Bool
    var nonUrban: Bool
    
    private var urbanCurrentVal: Int { return urban ? 2 : 0 }
    private var nonUrbanCurrentVal: Int { return nonUrban ? 1 : 0 }
    var value: Int { return urbanCurrentVal + nonUrbanCurrentVal }
}

enum WeekdayType: Int {
    case Sun, Mon, Tue, Wed, Thu, Fri, Sat, All
}

public class Filter {
    var startDate = NSDate(timeIntervalSince1970: 1356991200) { didSet{ valueChanged() } } // Default: Jan 1st 2013
    var endDate = NSDate() { didSet{ valueChanged() } }  // Default: Now
   
    var showFatal = true { didSet{ valueChanged() } }
    var showSevere = true { didSet{ valueChanged() } }
    var showLight = true { didSet{ valueChanged() } }
    var showInaccurate = false { didSet{ valueChanged() } }
    var showAccurate = true { didSet{ valueChanged() } }
    
    var showUrban = UrbanType(urban: true, nonUrban: true) { didSet { valueChanged() } }
    var showIntersection = IntersectionType(showIn: true, showNot: true) { didSet { valueChanged() } }
    var showLane = LaneType(oneWay: true, bothWays: true) { didSet { valueChanged() } }
    var weekday = WeekdayType.All { didSet{ valueChanged() } }
    
    var description: String {
        let valsAndNames = [
            "Fatal": showFatal,
            "Severe": showSevere,
            "Light": showLight,
            "Inaccurate": showInaccurate,
            "Accurate": showAccurate,
            "Urban" : showUrban.value,
            "Intersection" : showIntersection.value,
            "Lane" : showLane.value,
            "Weekday" : weekday.rawValue
        ]
        let pref = "_______[ Filter Details ]_______\n"
        let suff = "\n________________________________\n"
        return valsAndNames.reduce(pref) { return "\($0) | \($1.0): \($1.1)" } + suff
    }
    
    var onChange: ()->() = {}
    func valueChanged() { print("filter changed"); onChange() }
}