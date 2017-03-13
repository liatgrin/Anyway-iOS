//
//  ViewController+Table.swift
//  Anyway
//
//  Created by Aviel Gross on 14/12/2015.
//  Copyright © 2015 Hasadna. All rights reserved.
//

import UIKit

/**
 Filter Table View Logic
*/
extension ViewController {
    
    enum TableViewState { case closed, filter }
        
    func openTableView(_ type: TableViewState) {
        tableViewState = type
        constraintTableViewBottom.constant = 0
        view.bringSubview(toFront: tableViewContainer)
        UIView.animate(withDuration: 0.25, animations: {
            self.tableViewContainer.layoutIfNeeded()
        }) 
    }
    
    func closeTableView() {
        tableViewState = .closed
        
        constraintTableViewBottom.constant = -constraintTableViewHeight.constant
        UIView.animate(withDuration: 0.25, animations:{
            self.tableViewContainer.layoutIfNeeded()
        }, completion: { _ in }) 
    }
    
    func numberOfRowsForFilterTable(section s: Int) -> Int {
        switch s {
        case 0: return 2
        case 1: return 3
        case 2: return 2
        default: return 0
        }
    }
    
    func totalRowsForFilterTable() -> Int {
        return Array.init(repeating: 0, count: numberOfSections(in: tableView))
            .enumerated()
            .map{ i, _ in i }
            .map{ i in numberOfRowsForFilterTable(section: i)}
            .reduce(0, +)
    }
    
}

/**
 Managing the filter table view UI
 
    Data for populating the table is
    harcoded. Much of the logic and data
    is in 'FilterCellTableViewCell' and
    is defined by setting it's 'filterType'.
 
*/
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: UITableViewDataSource
    /* 
        What to show? 
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsForFilterTable(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateId = "dateFilterCellIdentifier"
        let switchId = "switchFilterCellIdentifier"
        var cell: FilterCellTableViewCell!
        
        switch (indexPath.row, indexPath.section) {
            //        case (0, 0): fallthrough //Pick start date
        case (_, 0):             //Pick end date
            cell = tableView.dequeueReusableCell(withIdentifier: dateId) as! FilterCellTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.default
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: switchId) as! FilterCellTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        switch (indexPath.row, indexPath.section) {
        case (0, 0): cell.filterType = .startDate
        case (1, 0): cell.filterType = .endDate
        case (0, 1): cell.filterType = .showFatal
        case (1, 1): cell.filterType = .showSevere
        case (2, 1): cell.filterType = .showLight
        case (0, 2): cell.filterType = .showAccurate
        case (1, 2): cell.filterType = .showInaccurate
        default: break
        }
        
        cell.filter = filter
        
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    /* 
        - How to show it?
        - What to do on when X happens?
    */
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row, indexPath.section) {
        case (0, 0): //Pick start date
            dateSelectionType = .start
            closeTableView()
            openDateSelectionController()
        case (1, 0): //Pick end date
            dateSelectionType = .end
            closeTableView()
            openDateSelectionController()
        default:
            break
        }
        
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //MARK: UIScrollViewDelegate
    /* 
        What to do when the table (which
        is actually a UISCrollView
        subclass...) moves/gets dragged?
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            constraintTableViewBottom.constant += scrollView.contentOffset.y
            constraintTableViewBottom.constant = min(0, constraintTableViewBottom.constant)
            scrollView.contentOffset = CGPoint.zero
            tableView.setNeedsLayout()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tableView {
            let delta = constraintTableViewHeight.constant / 3
            if abs(constraintTableViewBottom.constant) > delta || velocity.y < -1 {
                closeTableView()
            } else {
                openTableView(tableViewState)
            }
        }
    }
}
