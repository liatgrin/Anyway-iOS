//
//  Marker.swift
//  Anyway
//
//  Created by Aviel Gross on 2/16/15.
//  Copyright (c) 2015 Hasadna. All rights reserved.
//

import UIKit
import MapKit


class Marker : NSObject, MarkerAnnotation {
    
    var title: String? { return localizedSubtype }
    var coordinate: CLLocationCoordinate2D
    
    var address: String = ""
    var descriptionContent: String = ""
    var titleAccident: String = ""
    var created: Date = Date(timeIntervalSince1970: 0)
    var followers: [AnyObject] = []
    var following: Bool = false
    var id: Int = 0
    var locationAccuracy: Int = 0
    var severity: Int = 0
    var subtype: Int = 0
    var type: Int = 0
    var user: String = ""
    
    //new
    var roadShape: Int = -1
    var cross_mode: Int = -1
    var secondaryStreet: String = ""
    var cross_location: Int = -1
    var one_lane: Int = -1
    var speed_limit: Int = -1
    var weather: Int = -1
    var provider_code: Int = -1
    var road_object: Int = -1
    var didnt_cross: Int = -1
    var object_distance: Int = -1
    var road_sign: Int = -1
    var intactness: Int = -1
    var junction: String = ""
    var road_control: Int = -1
    var road_light: Int = -1
    var multi_lane: Int = -1
    var dayType: Int = -1
    var unit: Int = -1
    var road_width: Int = -1
    var cross_direction: Int = -1
    var roadType: Int = -1
    var road_surface: Int = -1
    var mainStreet: String = ""
    
    convenience init(coord: Coordinate, address: String, content: String, title: String, created: Date, id: Int, accuracy: Int, severity: Int, subtype: Int, type: Int) {
        self.init(coordinate: coord)
        self.coordinate = coord
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
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}

/// Helper methods to determine which information
/// is available for presentation.
extension Marker: PairsData {
    
    var roadConditionData: [(Title, Detail)] {
        return [
            Marker.pair(forType: .sug_DERECH, value: roadType),
            Marker.pair(forType: .zurat_DEREH, value: roadShape),
            Marker.pair(forType: .had_MASLUL, value: one_lane),
            Marker.pair(forType: .mehirut_MUTERET, value: speed_limit),
            Marker.pair(forType: .tkinut, value: intactness),
            Marker.pair(forType: .rohav, value: road_width),
            Marker.pair(forType: .simun_TIMRUR, value: road_sign),
            Marker.pair(forType: .teura, value: road_light),
            Marker.pair(forType: .bakara, value: road_control),
            Marker.pair(forType: .mezeg_AVIR, value: weather)
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
        return Localization.sug_TEUNA[subtype] ?? ""
    }
    
    var localizedSeverity: String {
        return Localization.humrat_TEUNA[severity] ?? ""
    }
    
    var localizedAccuracy: String {
        return Localization.status_IGUN[locationAccuracy] ?? ""
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



