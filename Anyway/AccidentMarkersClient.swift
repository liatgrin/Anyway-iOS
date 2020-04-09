//
//  AccidentMarkersClient.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/03/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

//protocol NewMarker {
//    var coordinate: Coordinate { get }
//}

class AccidentMarker: NSObject, Decodable {

    let id: String
    let created: Date
    let providerCode: Int

    let latitude: Double
    let longitude: Double
    let locationAccuracy: Int

    let accidentSeverity: Int
    let accidentYear: Int

    private enum CodingKeys: String, CodingKey {
        case providerCode = "provider_code"
        case accidentSeverity = "accident_severity"
        case locationAccuracy = "location_accuracy"
        case accidentYear = "accident_year"

        case id, created, latitude, longitude
    }

    static func from(json: JSON) -> AccidentMarker? {
        let marker: AccidentMarker?
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601Local
            marker = try decoder.decode(AccidentMarker.self, from: json.rawData())
        }
        catch(let e) {
            print(e)
            marker = nil
        }
        return marker
    }
}

class AccidentDetails: Decodable {

    let address: String?
    let description: String?
    let title: String?

    let subtype: Int?
    let type: Int?

    let roadShape: Int
    let crossMode: Int
    let secondaryStreet: String
    let crossLocation: Int
    let oneLane: Int
    let speedLimit: Int
    let weather: Int
    let roadObject: Int
    let didntCross: Int
    let objectDistance: Int
    let roadSign: Int
    let intactness: Int
    let roadControl: Int
    let roadLight: Int
    let multiLane: Int
    let dayType: Int
    let unit: Int
    let roadWidth: Int
    let crossDirection: Int
    let roadType: Int
    let roadSurface: Int
    //    let mainStreet = marker["secondaryStreet"].stringValue
    //    let junction = marker["secondaryStreet"].stringValue

    private enum CodingKeys: String, CodingKey {
        case crossMode = "cross_mode"
        case crossLocation = "cross_location"
        case oneLane = "one_lane"
        case speedLimit = "speed_limit"
        case roadObject = "road_object"
        case didntCross = "didnt_cross"
        case objectDistance = "object_distance"
        case roadSign = "road_sign"
        case roadControl = "road_control"
        case roadLight = "road_light"
        case multiLane = "multi_lane"
        case roadWidth = "road_width"
        case crossDirection = "cross_direction"
        case roadSurface = "road_surface"

        case address, description, title, subtype, type, roadShape, secondaryStreet,
            weather, intactness, dayType, unit, roadType
    }

    static func from(json: JSON) -> AccidentDetails? {
        return try? JSONDecoder().decode(AccidentDetails.self, from: json.rawData())
    }
}

//struct AccidentMarkerGroup: NewMarker {
//
//    let coordinate: Coordinate
//    let markers: [AccidentMarker]
//
//}

fileprivate struct MarkerParams: Encodable {

    let northEastLatitude: CLLocationDegrees
    let northEastLongitude: CLLocationDegrees
    let southWestLatitude: CLLocationDegrees
    let southWestLongitude: CLLocationDegrees

    let startDate: Int
    let endDate: Int

    let showFatal: Bool
    let showSevere: Bool
    let showLight: Bool

    let accurate: Bool
    let approx: Bool

    let showIntersection: Int
    let showLane: Int
    let showUrban: Int

    let showDay: Int
    let showHoliday: Int
    let showTime: Int
    let weather: Int

    let showMarkers = 1
    let showDiscissions = 0 // TODO: make configurable

    let zoom = 16 // minimum
    let thinMarkers = 1 // not used (server logic determenines this)

    // TODO: Add these as options in filter with UI
    let startTime = 25
    let endTime = 25
    let road = 0
    let separation = 0
    let surface = 0
    let accidentType = 0
    let controlMeasure = 0
    let district = 0
    let caseType = 0

    private enum CodingKeys: String, CodingKey {
        case northEastLatitude = "ne_lat"
        case northEastLongitude = "ne_lng"
        case southWestLatitude = "sw_lat"
        case southWestLongitude = "sw_lng"
        case startDate = "start_date"
        case endDate = "end_date"
        case showFatal = "show_fatal"
        case showSevere = "show_severe"
        case showLight = "show_light"
        case showIntersection = "show_intersection"
        case showLane = "show_lane"
        case showUrban = "show_urban"
        case showDay = "show_day"
        case showHoliday = "show_holiday"
        case showTime = "show_time"
        case showMarkers = "show_markers"
        case showDiscissions = "show_discussions"
        case thinMarkers = "thin_markers"
        case startTime = "start_time"
        case endTime = "end_time"
        case accidentType = "acctype"
        case controlMeasure = "controlmeasure"
        case caseType = "case_type"

        case zoom, accurate, approx, weather, road, separation, surface, district
    }

    func toJSON() -> [String: Any]? {
        return try? JSON(data: try! JSONEncoder().encode(self)).dictionaryObject
    }
}


class AccidentMarkersClient {

    public static let shared = AccidentMarkersClient()
    let markersUrl = "http://www.anyway.co.il/markers"
    let lock = NSConditionLock()

    private init() {}

    func getAccidentMarkers(around center: Coordinate, filter: Filter, completion: @escaping ([AccidentMarker]?) -> Void) {
        guard self.lock.try() else { return }

        let params = self.buildMarkerParams(center, filter)
        AF.request(markersUrl, parameters: params.toJSON()).responseJSON { responseValue in

            let markers: [AccidentMarker]?

            switch responseValue.result {
            case .failure(let err):
                print("Error! \(err)")
                markers = nil
            case .success(let value):
                let jsonMarkers = JSON(value)["markers"].array ?? []
                markers = jsonMarkers.compactMap { AccidentMarker.from(json: $0) }
//                let mapping: [NSValue:[Any]] = markers.reduce(into: [:]) { (result, marker) in
//                    let key = NSValue(mkCoordinate: marker.coordinate)
//                    result.appendOrInsert(to: key, element: marker)
//                }
//                groupedMarkers = mapping.map { key, value in
//                    if value.count == 1 {
//                        return value.first! as! NewMarker
//                    }
//                    else {
//                        return AccidentMarkerGroup(coordinate: key.mkCoordinateValue, markers: value as! [AccidentMarker])
//                    }
//                }
            }

            completion(markers)
            self.lock.unlock()
        }
    }

    func getAccidentDetails(id: String, completion: @escaping (AccidentDetails?) -> Void) {
        let url = "\(self.markersUrl)/\(id)"
        AF.request(url).responseJSON { responseValue in

            let details: AccidentDetails?

            switch responseValue.result {
            case .failure(let err):
                print("Error! \(err)")
                details = nil
            case .success(let value):
                details = AccidentDetails.from(json: JSON(value))
            }

            completion(details)
        }
    }

    private func buildMarkerParams(_ center: Coordinate, _ filter: Filter) -> MarkerParams {
        // TODO: calculate params
        let edges = self.getSearchBoundary(center)
        return MarkerParams(northEastLatitude: edges.ne.latitude,
                            northEastLongitude: edges.ne.longitude,
                            southWestLatitude: edges.sw.latitude,
                            southWestLongitude: edges.sw.longitude,
                            startDate: Int(filter.startDate.timeIntervalSince1970),
                            endDate: Int(filter.endDate.timeIntervalSince1970),
                            showFatal: true,
                            showSevere: true,
                            showLight: true,
                            accurate: true,
                            approx: true,
                            showIntersection: filter.showIntersection.value,
                            showLane: filter.showLane.value,
                            showUrban: filter.showUrban.value,
                            showDay: filter.weekday.rawValue,
                            showHoliday: filter.holiday.rawValue,
                            showTime: filter.dayTime.rawValue,
                            weather: filter.weather.rawValue)

    }

    private func getSearchBoundary(_ center: Coordinate) -> Edges {
        // find the edges of the search area
        let areaDiameter = 500.0 // in meters

        let searchRadius = areaDiameter / 2
        let earthRadius = 6378.0 * 1000.0
        let degrees = (searchRadius / earthRadius) * (180.0 / .pi)

        let northEastLat = center.latitude + degrees
        let northEastLong = center.longitude + degrees / cos(center.latitude * .pi / 180.0)
        let northEast = Coordinate(latitude: northEastLat, longitude: northEastLong)

        let southWestLat = center.latitude - degrees
        let southWestLong = center.longitude - degrees / cos(center.latitude * .pi / 180.0)
        let southWest = Coordinate(latitude: southWestLat, longitude: southWestLong)

        return (ne: northEast, sw: southWest)
    }
}
