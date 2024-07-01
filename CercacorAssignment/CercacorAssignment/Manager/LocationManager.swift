//
//  LocationManager.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-30.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func requestLocationAuthorization(completion: @escaping (Result<Void, LocationError>) -> Void)
    func startUpdatingLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void)
    func getCurrentLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void)
    func stopUpdatingLocation()
}

class LocationManager: NSObject, LocationManagerDelegate {
    
    static let shared = LocationManager()
    private let clLocationManager: CLLocationManager
    
    private var authorizationCompletion: ((Result<Void, LocationError>) -> Void)?
    private var locationUpdateCompletion: ((Result<CLLocation, LocationError>) -> Void)?
    
    private override init() {
        self.clLocationManager = CLLocationManager()
        super.init()
        self.clLocationManager.delegate = self
    }
    
    private func handleAuthorization(completion: @escaping (Result<Void, LocationError>) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.failure(.locationServicesDisabled))
            return
        }
        switch self.clLocationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(.success(()))
        case .denied:
            completion(.failure(.authorizationDenied))
        case .notDetermined:
            completion(.failure(.authorizationNotDetermined))
        case .restricted:
            completion(.failure(.authorizationRestricted))
        @unknown default:
            fatalError("Unknown error")
        }
    }
    
    func requestLocationAuthorization(completion: @escaping (Result<Void, LocationError>) -> Void) {
        self.handleAuthorization { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                switch error {
                case .authorizationNotDetermined:
                    self.authorizationCompletion = completion
                    self.clLocationManager.requestWhenInUseAuthorization()
                default:
                    completion(.failure(error))
                }
            }
        }
    }
    
    func startUpdatingLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void) {
        self.handleAuthorization { result in
            switch result {
            case .success:
                self.locationUpdateCompletion = completion
                self.clLocationManager.startUpdatingLocation()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void) {
        
        self.handleAuthorization { result in
            switch result {
            case .success:
                self.locationUpdateCompletion = completion
                self.clLocationManager.requestLocation()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func stopUpdatingLocation() {
        self.clLocationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization granted, start location updates if needed
            self.authorizationCompletion?(.success(()))
            self.authorizationCompletion = nil
        case .denied, .restricted:
            // Authorization denied or restricted, handle accordingly
            self.authorizationCompletion?(.failure(status == .denied ? .authorizationDenied : .authorizationRestricted))
            self.authorizationCompletion = nil
        case .notDetermined:
            // Should not happen as we only request authorization when it's not determined
            break
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last  else { return }
        self.locationUpdateCompletion?(.success(location))
        self.locationUpdateCompletion = nil
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationUpdateCompletion?(.failure(.locationUpdateFailed(error)))
        self.locationUpdateCompletion = nil
    }
}
