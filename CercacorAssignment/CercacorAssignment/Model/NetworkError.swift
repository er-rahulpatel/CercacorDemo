//
//  NetworkError.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

enum NetworkError: Error {
    case configurationError
    case invalidUrl
    case APIError(ResponseError)
    case statusCodeUnavailable
    
    var description: String {
        switch self {
        case .configurationError:
            return "Configuration error"
        case .invalidUrl:
            return "Invalid URL"
        case .APIError(let error):
            return error.description
        case .statusCodeUnavailable:
            return "Invalid response"
        }
    }
}

enum ResponseError: Error, CaseIterable {
    case invalidRequest
    case unauthorized
    case forbidden
    case resourceNotFound
    case resourceAlreadyExists
    case internalServerError
    
    var statusCode: Int {
        switch self {
        case .invalidRequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .resourceNotFound:
            return 404
        case .resourceAlreadyExists:
            return 409
        case .internalServerError:
            return 500
        }
    }
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "Validation Error, Invalid input parameters, Invalid request"
        case .unauthorized:
            return "Unauthorized, Invalid auth keys, Usage limits exceeded, Missing tokens"
        case .forbidden:
            return "Forbidden, Disallowed entity"
        case .resourceNotFound:
            return "Resource not found"
        case .resourceAlreadyExists:
            return "Resource conflict, Resource already exists"
        case .internalServerError:
            return "Base error, internal server error, request failed"
        }
    }
    
    /// Returns error type from a given error code
    static func getErrorType(for statusCode: Int) -> ResponseError? {
        for responseError in self.allCases {
            if responseError.statusCode == statusCode {
                return responseError
            }
        }
        return nil
    }
    
}
