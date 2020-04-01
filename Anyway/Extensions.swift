//
//  Extensions.swift
//  Anyway
//
//  Created by Aviel Gross on 3/24/15.
//  Copyright (c) 2015 Hasadna. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue
            layer.borderColor = titleLabel?.textColor.cgColor ?? layer.borderColor
        }
    }
}

extension CLLocationCoordinate2D {
    var humanDescription: String {
        return "\(latitude),\(longitude)"
    }
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        
        var visibleAnots = [MKAnnotation]()
        let selfRegion = self.region
        
        for anot in self.annotations {
            if MKCoordinateRegionContainsPoint(selfRegion, anot.coordinate) {
                visibleAnots.append(anot)
            }
        }
        
        return visibleAnots
    }
}

extension CGSize {
    init(squareSide side: CGFloat) {
        self.init()
        width = side
        height = side
    }
}


extension DefaultsKeys {
    var locations: DefaultsKey<String?> { .init("locations") }
    var isTrackingHistory: DefaultsKey<Bool> { .init("isTrackingHistory", defaultValue: false) }
    var lastKnownLocation: DefaultsKey<Data?> { .init("lastKnownLocation") }
    var appLocal: DefaultsKey<String?> { .init("com.hasadna.anyway.AppLocal") }
    var appleLanguages: DefaultsKey<[String]?> { .init("AppleLanguages")}
}
