//
//  HistoryViewController.swift
//  Anyway
//
//  Created by Aviel Gross on 20/03/2017.
//  Copyright © 2017 Hasadna. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryViewController: UIViewController {
    static var storyboardId = "HistoryViewController"
    
    var data: Results<HistoryPosition>?
    var realm: Realm?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.realm = try? Realm()
            self?.data = self?.realm?.objects(HistoryPosition.self)
            self?.tableView.reloadData()
        }
        
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DATA: \(data?.count)")
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail cell", for: indexPath)
        
        let history = data?[indexPath.row]
        
        cell.textLabel?.text = history?.locationData.flatMap(CLLocation.from)?.description
        cell.detailTextLabel?.text = (history?.markers.count).flatMap{ "\($0) accidents" }
        
        return cell
    }
    
}
