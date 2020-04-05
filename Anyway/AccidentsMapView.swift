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
        LocationManager.shared.requireUserAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
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
        let reuseIdentifier = "accidentMarker"
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

                var annotations: [MKPointAnnotation] = []
                for marker in markers {
                    let annotation = MKPointAnnotation()
                    annotation.title = marker.id
                    annotation.subtitle = String(marker.accidentSeverity)
                    annotation.coordinate = Coordinate(latitude: marker.latitude, longitude: marker.longitude)
                    annotations.append(annotation)
                }
                mapView.addAnnotations(annotations)
            }
        }

//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//
//        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // TODO
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: self.reuseIdentifier)
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: self.reuseIdentifier)
            view.canShowCallout = true
            return view
        }
    }
}

struct AccidentsMapView_Previews: PreviewProvider {
    static var previews: some View {
        AccidentsMapView()
    }
}
