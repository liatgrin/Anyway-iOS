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

        /*
        form =
            
        Section("טווח תאריכים")
            
            <<< DateInlineRow() {
                $0.title = "תאריך התחלה"
                $0.value = filter.startDate
            }
            
            <<< DateInlineRow() {
                $0.title = "תאריך סיום"
                $0.value = filter.endDate
            }
            
            
        +++ Section("חומרה")
            
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
            
        
        +++ Section("עיגון")
            
            <<< CheckRow() {
                $0.title = "מדויק"
                $0.value = filter.showAccurate
            }
        
            <<< CheckRow() {
                $0.title = "מרחבי"
                $0.value = filter.showInaccurate
            }
        
            
            
        +++ Section("סוג דרך")
            
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
        */
        
        form += [datesSection(), severitySection(), accuracySection(), roadTypeSection(), weekdaySection()]
    }
    
    private func datesSection() -> Section {
            
        return Section("טווח תאריכים")
        
        <<< DateInlineRow() {
            $0.title = "תאריך התחלה"
            $0.value = filter.startDate
        }
        
        <<< DateInlineRow() {
            $0.title = "תאריך סיום"
            $0.value = filter.endDate
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
        
        return Section("יום")
        
        <<< SwitchRow("weekday_all") {
            $0.title = "הכל"
            $0.value = filter.weekday == .All
        }.onChange{ [weak self] row in
            guard let v = row.value else {return}
            self?.filter.weekday = v == true ? .All : WeekdayType.Sun
        }
            
        <<< SegmentedRow<Int>() {
            $0.options = [0, 1, 2, 3, 4, 5, 6]
            $0.value = filter.weekday == .All ? 0 : filter.weekday.rawValue
            $0.hidden = "$weekday_all == true"
            $0.displayValueFor = { v in
                return ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
                        .map{ local("FILTER_weekday_\($0)") }[v ?? 0]
                //return ["א׳", "ב׳", "ג׳", "ד׳", "ה׳", "ו׳", "ש׳"][v ?? 0]
            }
        }.onChange{ [weak self] row in
            guard let v = row.value, day = WeekdayType(rawValue: v)
                else {return}
            self?.filter.weekday = day
        }
        
    }
    
    
}