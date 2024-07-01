//
//  RestaurantViewModel.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-29.
//

import Foundation
import MapKit

class RestaurantViewModel: ObservableObject {
    let locationManager: LocationManagerDelegate
    private let searchDistance: CLLocationDistance = 500
    @Published var restaurants: [Restaurant] = []
    @Published var foodName: String? {
        didSet {
            fetchCurrentLocation()
        }
    }
    @Published var currentLocation: CLLocation? {
        didSet {
            if let foodName = self.foodName,  let coordinate = self.currentLocation?.coordinate{
                searchNearByRestaurants(for: foodName, at: coordinate)
            }
        }
    }
    @Published var selectedViewType: RestaurantViewType = .map
    @Published var isError: Bool = false
    var errorMessage: String = ""
    
    init(locationManager: LocationManagerDelegate, foodName: String) {
        self.locationManager = locationManager
        self.foodName = foodName
    }
    /// get user's current location
    func fetchCurrentLocation() {
        Task {
            self.locationManager.requestLocationAuthorization { result in
                switch result {
                case .success:
                    self.locationManager.getCurrentLocation { result in
                        switch result {
                        case .success(let location):
                            // Handle location
                            DispatchQueue.main.async {[weak self] in
                                guard let weakSelf = self else  {
                                    return
                                }
                                weakSelf.currentLocation = location
                            }
                            
                            
                        case .failure(let error):
                            DispatchQueue.main.async {[weak self] in
                                guard let weakSelf = self else  {
                                    return
                                }
                                weakSelf.handleError(error)
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
                        guard let weakSelf = self else  {
                            return
                        }
                        weakSelf.handleError(error)
                    }
                }
            }
        }
        
    }
    
    /// API response error handling
    func handleError(_ error: Error) {
        self.isError = true
        if let error = error as? LocationError {
            self.errorMessage = error.description
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// search nearby locations with native mapkit api
    func searchNearByRestaurants(for foodName: String, at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = foodName
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: searchDistance, longitudinalMeters: searchDistance)
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant,.bakery,.foodMarket, .winery, .cafe, .brewery])
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response else {
                print("No response found")
                return
            }
            self.restaurants = response.mapItems.map {
                Restaurant(placemark: $0.placemark)
            }
        }
    }
}



