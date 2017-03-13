//
//  ViewController+LocationServices.swift
//  Anyway
//
//  Created by Aviel Gross on 04/01/2016.
//  Copyright © 2016 Hasadna. All rights reserved.
//

import Foundation

/**
 Handling location services for the main screen
*/
extension ViewController {
    
    func isLocationMonitoringAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    
    
    func beginTrackingLocation() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined: //NEVER ASKED
            let sel = #selector(CLLocationManager.requestWhenInUseAuthorization)
            if locationManager.responds(to: sel) {
                locationManager.requestWhenInUseAuthorization() //iOS 8+
            } else {
                locationManager.startUpdatingLocation() //iOS 7
            }
            
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse: //GRANTED
            map.showsUserLocation = true
            
        case .restricted: //RESTRICTED
            break
            
        case .denied: //DENIED
            break
            
        }
        
    }
    
}
