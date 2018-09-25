//
//  HistoryPosition.swift
//  Anyway
//
//  Created by Aviel Gross on 20/03/2017.
//  Copyright © 2017 Hasadna. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryPosition: Object {
    
    @objc dynamic var locationData: Data?
    @objc dynamic var locationPLacemark: Data?
    var markers = List<Marker>()
    
}
