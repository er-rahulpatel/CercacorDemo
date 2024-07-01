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
    func searchInstantFoodItemsWith<Item>(parameters: SearchInstantEndPointParameter) async throws -> Item where Item : Decodable {
        switch mockResponse {
        case .success(let response):
            return response as! Item
        case .failure(let error):
            throw error
        }
    }
    
    func searchItemForBrandedFoodWith<Item>(parameters: SearchItemEndPointParameter) async throws -> Item where Item : Decodable {
        switch mockResponse {
        case .success(let response):
            return response as! Item
        case .failure(let error):
            throw error
        }
    }
    
    func naturalNutrientForCommonFoodWith<Item>(parameters: NaturalNutrientsEndPointParameter) async throws -> Item where Item : Decodable {
        switch mockResponse {
        case .success(let response):
            return response as! Item
        case .failure(let error):
            throw error
        }
    }
    
    var mockResponse: Result<Any, Error>
    
    init(mockResponse: Result<Any, Error>) {
        self.mockResponse = mockResponse
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
