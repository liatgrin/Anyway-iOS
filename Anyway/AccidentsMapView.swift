//
//  AccidentsMapView.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/03/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftLocation

struct AccidentsMapView: UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard

        LocationManager.shared.requireUserAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        mapView.register(FatalAccidentMarkerView.self, forAnnotationViewWithReuseIdentifier: String(describing: Severity.fatal))
        mapView.register(SevereAccidentMarkerView.self, forAnnotationViewWithReuseIdentifier: String(describing: Severity.severe))
        mapView.register(LightAccidentMarkerView.self, forAnnotationViewWithReuseIdentifier: String(describing: Severity.light))
        mapView.register(AccidentClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
//        let region = MKCoordinateRegion(center: uiView.centerCoordinate, span: span)
//        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AccidentsMapView
        let client = AccidentMarkersClient.shared
        let coord = Coordinate(latitude: 0, longitude: 0)

        init(_ parent: AccidentsMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print(mapView.centerCoordinate)

            guard CLLocation.distance(from: coord, to: mapView.centerCoordinate) > 50 else {
                return
            }

            self.client.getAccidentMarkers(around: mapView.centerCoordinate, filter: Filter()) { markers in
                guard let markers = markers else { return }

                // TODO: check for change
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(markers)
            }
        }

//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//
//        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let marker = annotation as? AccidentMarker {
                switch Severity(rawValue: marker.accidentSeverity) {
                case .fatal:
                    return mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: Severity.fatal), for: marker)
                case .severe:
                    return mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: Severity.severe), for: marker)
                case .light:
                    return mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: Severity.light), for: marker)
                default:
                    return AccidentMarkerView(annotation: marker, reuseIdentifier: nil) // TODO: why???
                }
            }
            else if let cluster = annotation as? MKClusterAnnotation {
                return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: cluster)
            }

            return nil
        }
    }
}

struct AccidentsMapView_Previews: PreviewProvider {
    static var previews: some View {
        AccidentsMapView()
    }
}
