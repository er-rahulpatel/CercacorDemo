//
//  RestaurantMap.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-30.
//

import SwiftUI
import MapKit

struct RestaurantMap: UIViewRepresentable {
    let restaurants: [Restaurant]
    @State var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        // Center map on current location
        let annotations = getAnnotations()
        mapView.setRegion(region(for: annotations), animated: false)
        
        // Add annotations
        mapView.addAnnotations(annotations)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update annotations if restaurants change
        mapView.removeAnnotations(mapView.annotations)
        let annotations = getAnnotations()
        mapView.addAnnotations(getAnnotations())
        mapView.setRegion(region(for: annotations), animated: false)
    }
    
    private func getAnnotations() -> [MKAnnotation] {
        return restaurants.map { restaurant in
            let annotation = MKPointAnnotation()
            annotation.coordinate = restaurant.coordinate
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.title
            return annotation
        }
    }
    
    private func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        guard !annotations.isEmpty else {
            // Default region if there are no annotations
            return MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        }
        var minLat = annotations.map { $0.coordinate.latitude }.min() ?? coordinate.latitude
        var minLon = annotations.map { $0.coordinate.longitude }.min() ?? coordinate.longitude
        var maxLat = annotations.map { $0.coordinate.latitude }.max() ?? coordinate.latitude
        var maxLon = annotations.map { $0.coordinate.longitude }.max() ?? coordinate.longitude
        
        minLat = min(minLat, coordinate.latitude)
        minLon = min(minLon, coordinate.longitude)
        maxLat = max(maxLat, coordinate.latitude)
        maxLon = max(maxLon, coordinate.longitude)
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLon - minLon) * 1.1)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: RestaurantMap
    
    init(_ parent: RestaurantMap) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // guard let restaurantName = view.annotation?.title else { return }
        // Find the selected restaurant by name
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        parent.coordinate = location.coordinate
    }
}

struct RestaurantMap_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMap(restaurants: [], coordinate: CLLocationCoordinate2D())
    }
}
