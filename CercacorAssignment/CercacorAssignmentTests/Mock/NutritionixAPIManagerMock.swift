//
//  NutritionixAPIManagerMock.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import Foundation
@testable import CercacorAssignment

protocol MockResponseProvider {
    associatedtype Element
    static var successDataResponse: Data { get }
    static var successResponse: Element { get }
    static var failureResponse: Error { get }
}

class NutritionixAPIManagerMock: NutritionixAPIManagerDelegate {
    var mockResponse: Result<Any, Error>
    
    init(mockResponse: Result<Any, Error>) {
        self.mockResponse = mockResponse
    }
    
    func getFoodItemsByInstantSearch<Item: Decodable>(query: String, includeCommonFoodItem: Bool = false) async throws -> Item {
        switch mockResponse {
        case .success(let response):
            return response as! Item
        case .failure(let error):
            throw error
        }
    }
    
    func getFoodItemsByNixId<Item: Decodable>(_ nixId: String) async throws -> Item {
        switch mockResponse {
        case .success(let response):
            return response as! Item
        case .failure(let error):
            throw error
        }
    }
}

struct SearchInstantEndPointResponseMock: MockResponseProvider {
    typealias Element =  SearchInstantEndPointResponse
    static var successResponse: SearchInstantEndPointResponse {
        try! JSONDecoder().decode(SearchInstantEndPointResponse.self, from: successDataResponse)
    }
    
    static var successDataResponse: Data {
        // Define your mock success response here
        let filePath = Bundle.main.path(forResource: "SearchInstantMock", ofType: "json")!
        let fileUrl  = URL(fileURLWithPath: filePath)
        return try! Data(contentsOf: fileUrl)
        
    }
    
    static var failureResponse: Error { NetworkError.invalidUrl }
}

struct SearchItemEndPointResponseMock: MockResponseProvider {
    typealias Element =  SearchItemEndPointResponse
    static var successResponse: SearchItemEndPointResponse {
        try! JSONDecoder().decode(SearchItemEndPointResponse.self, from: successDataResponse)
    }
    
    static var successDataResponse: Data {
        // Define your mock success response here
        let filePath = Bundle.main.path(forResource: "SearchItemMock", ofType: "json")!
        let fileUrl  = URL(fileURLWithPath: filePath)
        return try! Data(contentsOf: fileUrl)
        
    }
    
    static var failureResponse: Error { NetworkError.invalidUrl }
}
