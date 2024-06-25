//
//  NutritionixAPIManager.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

protocol NutritionixAPIManagerDelegate {
    func getFoodItemsByInstantSearch<Item: Decodable>(query: String, includeCommonFoodItem: Bool) async throws -> Item
    
    func getFoodItemsByNixId<Item: Decodable>(_ nixId: String) async throws -> Item
}

class NutritionixAPIManager: NutritionixAPIManagerDelegate {
    private let nutritionixConfiguration: NutritionixConfiguration
    private let networkManager: NetworkManagerDelegate
    
    init(nutritionixConfiguration: NutritionixConfiguration, networkManager: NetworkManagerDelegate) {
        self.nutritionixConfiguration = nutritionixConfiguration
        self.networkManager = networkManager
    }
    ///Manages searchInstant endpoint request
    func getFoodItemsByInstantSearch<Item: Decodable>(query: String, includeCommonFoodItem: Bool = false) async throws -> Item {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "common", value: includeCommonFoodItem ? "true" : "false")
        ]
        
        let request = try APIEndPoint.searchInstant.urlRequest(for: queryItems, nutritionixConfiguration: self.nutritionixConfiguration)
        let (data, _) = try await self.networkManager.make(request: request)
        return try self.networkManager.parseData(data: data)
    }
    ///Manages searchItem endpoint request
    func getFoodItemsByNixId<Item: Decodable>(_ nixId: String) async throws -> Item {
        let queryItems = [
            URLQueryItem(name: "nix_item_id", value: nixId),
        ]
        
        let request = try APIEndPoint.searchItem.urlRequest(for: queryItems, nutritionixConfiguration: self.nutritionixConfiguration)
        let (data, _) = try await self.networkManager.make(request: request)
        return try self.networkManager.parseData(data: data)
    }
}
