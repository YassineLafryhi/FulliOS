//
//  MapsView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 19/7/2024.
//

import CoreLocation
import MapKit
import SwiftUI

internal struct MapsView: UIViewControllerRepresentable {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var mapView = MKMapView()

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true

        let locationManager = CLLocationManager()
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        viewController.view = mapView
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context _: Context) {
        if let mapView = uiViewController.view as? MKMapView {
            mapView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapsView

        init(_ parent: MapsView) {
            self.parent = parent
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                if let placemark = placemarks?.first, let country = placemark.country {
                    print("User's country: \(country)")
                    withAnimation {
                        self.parent.region = MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        self.parent.mapView.setRegion(self.parent.region, animated: true)
                    }
                }
            }
            manager.stopUpdatingLocation()
        }

        func locationManager(_: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    }
}
