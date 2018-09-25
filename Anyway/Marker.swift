//
//  Marker.swift
//  Anyway
//
//  Created by Aviel Gross on 2/16/15.
//  Copyright (c) 2015 Hasadna. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class Marker: Object, MarkerAnnotation {
    
    
    @objc dynamic var coordinateLat: Double = 0
    @objc dynamic var coordinateLon: Double = 0
    
    @objc dynamic var address: String = ""
    @objc dynamic var descriptionContent: String = ""
    @objc dynamic var titleAccident: String = ""
    @objc dynamic var created: Date = Date(timeIntervalSince1970: 0)
    var followers: [AnyObject] = []
    @objc dynamic var following: Bool = false
    @objc dynamic var id: Int = 0
    @objc dynamic var locationAccuracy: Int = 0
    @objc dynamic var severity: Int = 0
    @objc dynamic var subtype: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var user: String = ""
    
    @objc dynamic var roadShape: Int = -1
    @objc dynamic var cross_mode: Int = -1
    @objc dynamic var secondaryStreet: String = ""
    @objc dynamic var cross_location: Int = -1
    @objc dynamic var one_lane: Int = -1
    @objc dynamic var speed_limit: Int = -1
    @objc dynamic var weather: Int = -1
    @objc dynamic var provider_code: Int = -1
    @objc dynamic var road_object: Int = -1
    @objc dynamic var didnt_cross: Int = -1
    @objc dynamic var object_distance: Int = -1
    @objc dynamic var road_sign: Int = -1
    @objc dynamic var intactness: Int = -1
    @objc dynamic var junction: String = ""
    @objc dynamic var road_control: Int = -1
    @objc dynamic var road_light: Int = -1
    @objc dynamic var multi_lane: Int = -1
    @objc dynamic var dayType: Int = -1
    @objc dynamic var unit: Int = -1
    @objc dynamic var road_width: Int = -1
    @objc dynamic var cross_direction: Int = -1
    @objc dynamic var roadType: Int = -1
    @objc dynamic var road_surface: Int = -1
    @objc dynamic var mainStreet: String = ""
    
    
    /// Properties ignored by Realm
    override class func ignoredProperties() -> [String] {
        return ["coordinate", "followers"]
    }
}

/// Convenience inits
extension Marker {
    
    convenience init(coord: Coordinate, address: String, content: String, title: String, created: Date, id: Int, accuracy: Int, severity: Int, subtype: Int, type: Int) {
        self.init(coordinate: coord)
        self.address = address
        self.descriptionContent = content
        self.titleAccident = title
        self.created = created
        self.id = id
        self.locationAccuracy = accuracy
        self.severity = severity
        self.subtype = subtype
        self.type = type
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
}


/// Computed vards
extension Marker {
    var title: String? { return localizedSubtype }
    
    var coordinate: CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: coordinateLat, longitude: coordinateLon)
        }
        set{
            coordinateLat = newValue.latitude
            coordinateLon = newValue.longitude
        }
    }
}

/// Helper methods to determine which information
/// is available for presentation.
extension Marker: PairsData {
    
    var roadConditionData: [(Title, Detail)] {
        return [
            Marker.pair(forType: .SUG_DERECH, value: roadType),
            Marker.pair(forType: .ZURAT_DEREH, value: roadShape),
            Marker.pair(forType: .HAD_MASLUL, value: one_lane),
            Marker.pair(forType: .MHIRUT_MUTERET, value: speed_limit),
            Marker.pair(forType: .TKINUT, value: intactness),
            Marker.pair(forType: .ROHAV, value: road_width),
            Marker.pair(forType: .SIMUN_TIMRUR, value: road_sign),
            Marker.pair(forType: .TEURA, value: road_light),
            Marker.pair(forType: .BAKARA, value: road_control),
            Marker.pair(forType: .MEZEG_AVIR, value: weather)
            ].flatMap{ $0 }
    }
    
}

/// Implement "subtitle" param declared in 'MKAnnotation'
extension Marker {
    var subtitle: String? { return localizedSeverity }
}

/// Localized descriptions for Marker
extension Marker: VisualMarker {
    //MARK: Localized Info
    
    var localizedSubtype: String {
        return Localization.SUG_TEUNA[subtype] ?? ""
    }
    
    var localizedSeverity: String {
        return Localization.HUMRAT_TEUNA[severity] ?? ""
    }
    
    var localizedAccuracy: String {
        return Localization.STATUS_IGUN[locationAccuracy] ?? ""
    }
    
    var color: UIColor {
        switch severity {
        case 1: return Color.red
        case 2: return Color.orange
        case 3: return Color.yellow
        default: return Color.blue //should never happen
        }
    }
    
    var iconName: String? {
        return "ic_directions_car"
        
        /* 
            Previously we used different icons depend on accident
            type. Currently the icon is the same (following website
            design). This stays in case the design will change one day.
        
        var icons = [Severity:[AccidentType:String]]()
        icons[Severity.Fatal] = [
            AccidentType.CarToPedestrian : "vehicle_person_lethal.png",
            AccidentType.CarToCar : "vehicle_vehicle_lethal.png",
            AccidentType.CarToObject : "vehicle_object_lethal.png"]
        icons[Severity.Severe] = [
            AccidentType.CarToPedestrian : "vehicle_person_severe.png",
            AccidentType.CarToCar : "vehicle_vehicle_severe.png",
            AccidentType.CarToObject : "vehicle_object_severe.png"]
        icons[Severity.Light] = [
            AccidentType.CarToPedestrian : "vehicle_person_medium.png",
            AccidentType.CarToCar : "vehicle_vehicle_medium.png",
            AccidentType.CarToObject : "vehicle_object_medium.png"]

        if let sev = Severity(rawValue: severity),
            let someIcons = icons[sev],
            let minorType = AccidentMinorType(rawValue: subtype),
            let type = accidentMinorTypeToType(minorType),
            let icon = someIcons[type] {
                return icon
        }
        
        return nil
        */
    }
}



