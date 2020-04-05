//
//  Location.swift
//  Fame
//
//  Created by Aviel Gross on 5/20/15.
//  Copyright (c) 2015 Globalbit. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import SwiftyUserDefaults
import SwiftLocation

struct Location: Codable, DefaultsSerializable {
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let timestamp: Date

    init(from coreLocation: CLLocation) {
        self.longitude = coreLocation.coordinate.longitude
        self.latitude = coreLocation.coordinate.latitude
        self.timestamp = coreLocation.timestamp
    }

    private func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    func distance(from location: Location) -> CLLocationDistance {
        return self.toCLLocation().distance(from: location.toCLLocation())
    }
}

public extension Notification.Name {
    static var locationServicesDenied = Notification.Name("locationServicesDenied")
    static var locationServicesRestricted = Notification.Name("locationServicesRestricted")
    static var knownLocationChanged = Notification.Name("knownLocationChanged")
}

//public extension CLLocation {
//    var asData: Data { return NSKeyedArchiver.archivedData(withRootObject: self) }
//    class func from(_ data: Data) -> CLLocation? { return data.unarchived as? CLLocation ?? nil }
//}

public extension CLPlacemark {
    var asData: Data { return NSKeyedArchiver.archivedData(withRootObject: self) }
    class func from(_ data: Data) -> CLPlacemark? { return data.unarchived as? CLPlacemark ?? nil }
}

public class LocationStorage: NSObject {
    
    public static var shared = LocationStorage()

    let manager = LocationManager.shared
    var trackingRequest: LocationRequest!
    var realm: Realm?

    let maxDeltaForLastLocation: Seconds = 5
    
    var lastKnownLocation: Location? {
        set {
            guard let newValue = newValue else { return }
            Defaults.lastKnownLocation = newValue
            NotificationCenter.default.post(name: .knownLocationChanged, object: nil) // TODO
        }
        get {
            return Defaults.lastKnownLocation
        }
    }
    
    func recentLocation(maxSecondsFromNow maxSec: Seconds) -> Location? {
        if let loc = lastKnownLocation , loc.timestamp.timeIntervalSinceNow < maxSec {
            return loc
        }
        return nil
    }
    

    //MARK: - Logic
    
    public func beginTrackingLocation(requestAuthorizationIfNeeded shouldRequest: Bool) {
        // TODO: get authorization
        self.trackingRequest = self.manager.locateFromGPS(.significant, accuracy: .block, result: self.onUpdateLocation)
//        self.trackingRequest.start()
    }

    func onUpdateLocation(result: Result<CLLocation, LocationManager.ErrorReason>) {
        switch result {
        case .failure(let error):
            debugPrint("Received error: \(error)")
        case .success(let location):
            debugPrint("Location received: \(location)")
            self.lastKnownLocation = Location(from: location)
            self.updateHistory(location)
        }
    }

    func stopTrackingLocations() {
        self.trackingRequest.stop()
    }

    func updateHistory(_ loc: CLLocation) {
        print("🌎 updateHistory: \(loc)")
        log(loc)
        
        // find edges for area to search accidents
        let areaDiameter = 70 // in meters
        
        let center = loc.coordinate
        
        let d = Double(areaDiameter) / 2 // meters from center to each edge
        let r_earth = 6378.0 * 1000.0 // earth eprox radius
        let pi = Double.pi
        let neY = center.latitude + (d / r_earth) * (180.0 / pi)
        let neX = center.longitude + (d / r_earth) * (180.0 / pi) / cos(center.latitude * pi/180.0)
        let ne = Coordinate(latitude: neY, longitude: neX)
        
        let swY = center.latitude - (d / r_earth) * (180.0 / pi)
        let swX = center.longitude - (d / r_earth) * (180.0 / pi) / cos(center.latitude * pi/180.0)
        let sw = Coordinate(latitude: swY, longitude: swX)
        
        let edges = (ne: ne, sw: sw)
        
        // get accidents in area, save event with accidents
        Network().getAnnotations(edges, filter: Filter()) { [weak self] annotations, totalCount in
            guard totalCount > 0 else { return }
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { placemark, error in
                guard let place = placemark?.first else { return }
                
                do {
                    self?.realm = try Realm()
                    try self?.realm?.write {
                        let event = HistoryPosition()
                        for anot in annotations {
                            if let group = anot as? MarkerGroup {
                                event.markers.append(objectsIn: group.markers)
                            } else if let marker = anot as? Marker {
                                event.markers.append(marker)
                            }
                        }
                        // TODO: save to realn
//                        event.locationPLacemark = place.asData
//                        event.locationData = loc.asData
//                        self?.realm?.add(event)
                    }
                } catch {
                    print("Realm error: \(error)")
                }
                
                
            })
            
        }
        
        
    }
    
    //MARK: - Alerts
    
    func presentLocationsRestrictedAlert() {
        NotificationCenter.default.post(name: .locationServicesRestricted, object: nil)
    }
    
    func presentLocationsDeniedAlert() {
        NotificationCenter.default.post(name: .locationServicesDenied, object: nil)
    }
    
    //MARK: - Debug Actions
    
    func log(_ loc: CLLocation) {
        let desc = "\(loc.timestamp.shortDescription) :: \(loc.coordinate.latitude), \(loc.coordinate.longitude)"
        logString(desc)
    }
    
    func log(error: NSError!) {
        let desc = error.description
        print(desc)
    }
    
    func logString(_ str: String) {
        if let locs = Defaults.locations {
            Defaults.locations = "\(locs)\n\(str)"
        } else {
            Defaults.locations = str
        }
    }
}
