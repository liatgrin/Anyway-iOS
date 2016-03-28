//
//  FilterViewController+Setup.swift
//  Anyway
//
//  Created by Aviel Gross on 2/1/16.
//  Copyright © 2016 Hasadna. All rights reserved.
//

import Foundation
import Eureka


/**
 We build the filter screen using the open source
 library "Eureka!". It uses some Domain-Specific Language
 to setup to filter. The setup flow basically build a "form"
 that is presented in a UITableView.
 
 Read more here: https://github.com/xmartlabs/Eureka
*/
extension FilterViewController {
    
    /**
     Should be called from 'viewDidLoad()'
     to build the form.
     */
    internal func setupForm(filter: Filter) {

        form += [datesSection(), weekdaySection(),
            severitySection(), accuracySection(), roadTypeSection()]
    }
    
    
    
    private func datesSection() -> Section {
            
        return Section("טווח תאריכים")
        
        <<< DateInlineRow() {
            $0.title = "תאריך התחלה"
            $0.value = filter.startDate
        }.onChange{ [weak self] row in
            guard let d = row.value else {return}
            self?.filter.startDate = d
        }
        
        <<< DateInlineRow() {
            $0.title = "תאריך סיום"
            $0.value = filter.endDate
        }.onChange{ [weak self] row in
            guard let d = row.value else {return}
            self?.filter.endDate = d
        }
    }
    
    private func severitySection() -> Section {
        
        return Section("חומרה")
            
        <<< CheckRow() {
            $0.title = "קטלניות"
            $0.value = filter.showFatal
        }.cellUpdate { cell, row in
                cell.textLabel?.textColor = Color.red
        }.onChange{ [weak self] row in
                guard let v = row.value else {return}
                self?.filter.showFatal = v
        }
        
        <<< CheckRow() {
            $0.title = "קשות"
            $0.value = filter.showSevere
        }.cellUpdate { cell, row in
                cell.textLabel?.textColor = Color.orange
        }.onChange{ [weak self] row in
                guard let v = row.value else {return}
                self?.filter.showSevere = v
        }
        
        <<< CheckRow() {
            $0.title = "קלות"
            $0.value = filter.showLight
        }.cellUpdate { cell, row in
                cell.textLabel?.textColor = Color.yellow
        }.onChange{ [weak self] row in
                guard let v = row.value else {return}
                self?.filter.showLight = v
        }
    }
    
    private func accuracySection() -> Section {
        
        return Section("עיגון")
            
        <<< CheckRow() {
            $0.title = "מדויק"
            $0.value = filter.showAccurate
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showAccurate = v
        }
        
        <<< CheckRow() {
            $0.title = "מרחבי"
            $0.value = filter.showInaccurate
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showInaccurate = v
        }
        
    }
    
    private func roadTypeSection() -> Section {
        
        return Section("סוג דרך")
            
        <<< CheckRow() {
            $0.title = "בצומת"
            $0.value = filter.showIntersection.showIn
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showIntersection.showIn = v
        }
        
        <<< CheckRow() {
            $0.title = "לא בצומת"
            $0.value = filter.showIntersection.showNot
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showIntersection.showNot = v
        }
        
        <<< CheckRow() {
            $0.title = "חד-סטרי"
            $0.value = filter.showLane.oneWay
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showLane.oneWay = v
        }
        
        <<< CheckRow() {
            $0.title = "דו-סטרי"
            $0.value = filter.showLane.bothWays
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showLane.bothWays = v
        }
        
        <<< CheckRow() {
            $0.title = "עירוני"
            $0.value = filter.showUrban.urban
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showUrban.urban = v
        }
        
        <<< CheckRow() {
            $0.title = "לא עירוני"
            $0.value = filter.showUrban.nonUrban
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.showUrban.nonUrban = v
        }
        
    }
    
    private func weekdaySection() -> Section {
        
        return Section(local("FILTER_SECTION_day"))
        
        <<< SwitchRow("weekday_all") {
            $0.title = local("FILTER_weekday_all")
            $0.value = filter.weekday == .All
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.weekday = v == true ? .All : WeekdayType.Sun
        }
            
        <<< SegmentedRow<WeekdayType>() {
            $0.options = [.Sun, .Mon, .Tue, .Wed, .Thu, .Fri, .Sat]
            $0.value = filter.weekday == .All ? .Sun : filter.weekday
            $0.hidden = "$weekday_all == true"
            $0.displayValueFor = { v in return (v ?? WeekdayType.Sun).localized }
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.weekday = v
        }
        
        
        <<< ActionSheetRow<HolidayType>() {
            $0.title = local("SUG_YOM")
            $0.options = [.All, .Holiday, .HoliEve, .HoliWeekday, .Weekday]
            $0.value = filter.holiday
            $0.displayValueFor = { v in return (v ?? HolidayType.All).localized }
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.holiday = v
        }
        
        
        <<< ActionSheetRow<DayTimeType>() {
            $0.title = local("FILTER_ROW_day_time")
            $0.options = [.All, .Light, .Dark, .Morning, .Noon, .Evening, .Night]
            $0.value = filter.dayTime
            $0.displayValueFor = { v in return (v ?? DayTimeType.All).localized }
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.dayTime = v
        }
        
    }
    
    
}

