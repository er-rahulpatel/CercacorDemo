//
//  Restaurant.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-30.
//

import Foundation
import MapKit

struct Restaurant: Identifiable {
    let id = UUID()
    let placemark: MKPlacemark
    var name: String {
        self.placemark.name ?? ""
    }
    var title: String {
        self.placemark.title ?? ""
    }
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}
