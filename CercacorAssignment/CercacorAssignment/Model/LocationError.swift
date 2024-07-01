//
//  LocationError.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-30.
//

import Foundation

enum LocationError: Error {
    case locationServicesDisabled
    case authorizationDenied
    case authorizationNotDetermined
    case authorizationRestricted
    case locationUpdateFailed(Error)
    case timeout
    
    var description: String {
        switch self {
        case .locationServicesDisabled:
            return "Location services are disabled."
        case .authorizationDenied:
            return "Authorization to access location services has been denied."
        case .authorizationNotDetermined:
            return "Authorization to access location services has not been determined."
        case .authorizationRestricted:
            return "Authorization to access location services is restricted."
        case .locationUpdateFailed(let error):
            return "Failed to update location: \(error.localizedDescription)"
        case .timeout:
            return "Location request timed out."
        }
    }
}
