//
//  APIEndPoint.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

enum APIEndPoint {
    case searchInstant
    case searchItem
    
    private var host: String {
        "trackapi.nutritionix.com"
    }
    
    private var apiVersion: String {
        "v2"
    }
    
    private var contentType: String {
        "application/json"
    }
    
    var path: String {
        switch self {
        case .searchInstant:
            return "/search/instant"
        case .searchItem:
            return "/search/item"
        }
    }
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/" + apiVersion + self.path
        return components
    }
    
    private enum HeaderKeys: String {
        case contentType = "Content-Type"
        case xAppId = "x-app-id"
        case xAppKey = "x-app-key"
    }
    /// Request headers
    private func getHeaders(for nutritionixConfiguration:NutritionixConfiguration) -> [String: String] {
        var headers = [String: String]()
        headers[HeaderKeys.contentType.rawValue] = contentType
        headers[HeaderKeys.xAppId.rawValue] = nutritionixConfiguration.xAppId
        headers[HeaderKeys.xAppKey.rawValue] = nutritionixConfiguration.xAppKey
        return headers
    }
    
    // Create URL request to fetch data
    func urlRequest(for queryItems: [URLQueryItem], nutritionixConfiguration:NutritionixConfiguration, body: [String: AnyHashable]? = nil ) throws ->  URLRequest {
        
        var components = self.urlComponents
        components.queryItems = queryItems
        guard let url = components.url else{
            throw NetworkError.invalidUrl
        }
        var request = URLRequest(url: url)
        var httpMethod: String
        switch self {
        case .searchInstant, .searchItem:
            httpMethod = "GET"
        }
        request.httpMethod = httpMethod
        if let body = body{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        }
        request.allHTTPHeaderFields = getHeaders(for: nutritionixConfiguration)
        return request
    }
}
