//
//  ViewController+DatePicker.swift
//  Anyway
//
//  Created by Aviel Gross on 14/12/2015.
//  Copyright © 2015 Hasadna. All rights reserved.
//

import Foundation

/**
 Date picker for the filter "from" and "to" parameters
*/
extension ViewController: RMDateSelectionViewControllerDelegate {
    
    func dateSelectionViewController(_ vc: RMDateSelectionViewController!, didSelect aDate: Date!) {
        if dateSelectionType == .start {
            filter.startDate = aDate
        } else {
            filter.endDate = aDate
        }
        tableView?.reloadData()
        openTableView(.filter)
    }
    
    func dateSelectionViewControllerDidCancel(_ vc: RMDateSelectionViewController!) {
        openTableView(.filter)
    }
    
}
