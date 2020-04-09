//
//  Annotations.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/05/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//

import Foundation
import RealmSwift

typealias Coordinate = CLLocationCoordinate2D

extension AccidentMarker: MKAnnotation {

    var coordinate: Coordinate {
        Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}

//class AccidentAnnotation: NSObject, MKAnnotation {
//
//    let coordinate: Coordinate
//    let marker: AccidentMarker
//
//    var title: String? {
//        get {
//            return marker.id
//        }
//    }
//
//    var subtitle: String? {
//        get {
//            return String(marker.accidentSeverity)
//        }
//    }
//
//    init(with marker: AccidentMarker) {
//        self.coordinate = marker.coordinate
//        self.marker = marker
//    }
//
//}



//class AccidentClusterAnnotation: NSObject, MKAnnotation {
//
//    let coordinate: Coordinate
//    let markers: [AccidentMarker]
//
//    var title: String? {
//        get {
//            return String(markers.count)
//        }
//    }
//
//    var subtitle: String? {
//        get {
//            return String(self.highestSeverity)
//        }
//    }
//
//    private var highestSeverity: Int {
//        get {
//            return self.markers.max(by: { $0.accidentSeverity > $1.accidentSeverity })?.accidentSeverity ?? 0
//        }
//    }
//
//
//    init?(with markers: [AccidentMarker]) {
//        guard let coord = markers.first?.coordinate else { return nil }
//        self.coordinate = coord
//        self.markers = markers
//    }
//
//}
