//
//  AccidentMarkerView.swift
//  Anyway
//
//  Created by Liat Grinshpun on 04/09/2020.
//  Copyright © 2020 Hasadna. All rights reserved.
//


class AccidentMarkerView: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.canShowCallout = true
//        self.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)
        self.detailCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)

        self.glyphImage = UIImage(systemName: "car.fill")
        self.glyphTintColor = .white
        self.markerTintColor = .gray
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}

class FatalAccidentMarkerView: AccidentMarkerView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = String(describing: Severity.fatal)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.markerTintColor = .black
        self.displayPriority = .defaultHigh
    }
}

class SevereAccidentMarkerView: AccidentMarkerView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = String(describing: Severity.severe)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.markerTintColor = .red
        self.displayPriority = .defaultHigh
    }
}

class LightAccidentMarkerView: AccidentMarkerView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = String(describing: Severity.light)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.markerTintColor = .orange
        self.displayPriority = .defaultHigh
    }
}

class AccidentClusterView: AccidentMarkerView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let cluster = self.annotation as? MKClusterAnnotation,
            let marker = cluster.memberAnnotations.first as? AccidentMarker
        else { return }

        self.glyphText = String(cluster.memberAnnotations.count)

        switch Severity(rawValue: marker.accidentSeverity) {
        case .fatal:
            self.markerTintColor = .black
        case .severe:
            self.markerTintColor = .red
        case .light:
            self.markerTintColor = .orange
        default:
            break
        }
    }
}

