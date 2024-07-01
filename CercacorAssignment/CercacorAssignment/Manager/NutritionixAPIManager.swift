//
//  NutritionixAPIManager.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

protocol NutritionixAPIManagerDelegate {
    func searchInstantFoodItemsWith<Item: Decodable>(parameters: SearchInstantEndPointParameter) async throws -> Item
    func searchItemForBrandedFoodWith<Item: Decodable>(parameters: SearchItemEndPointParameter) async throws -> Item
    func naturalNutrientForCommonFoodWith<Item: Decodable>(parameters: NaturalNutrientsEndPointParameter) async throws -> Item
}

class NutritionixAPIManager: NutritionixAPIManagerDelegate {
    private let nutritionixConfiguration: NutritionixConfiguration
    private let networkManager: NetworkManagerDelegate
    
    init(nutritionixConfiguration: NutritionixConfiguration, networkManager: NetworkManagerDelegate) {
        self.nutritionixConfiguration = nutritionixConfiguration
        self.networkManager = networkManager
    }
    ///Manages searchInstant endpoint request
    func searchInstantFoodItemsWith<Item: Decodable>(parameters: SearchInstantEndPointParameter) async throws -> Item {
        let queryItems = SearchInstantEndPointParameter.Keys.allCases.map { key in
            URLQueryItem(name: key.rawValue, value: parameters.getValueFor(key: key))
        }
        
        let request = try APIEndPoint.searchInstant.urlRequest(with: self.nutritionixConfiguration, queryItems: queryItems)
        let (data, _) = try await self.networkManager.make(request: request)
        return try self.networkManager.parseData(data: data)
    }
    ///Manages searchItem endpoint request
    func searchItemForBrandedFoodWith<Item: Decodable>(parameters: SearchItemEndPointParameter) async throws -> Item {
        let queryItems = SearchItemEndPointParameter.Keys.allCases.map { key in
            URLQueryItem(name: key.rawValue, value: parameters.getValueFor(key: key))
        }
        
        let request = try APIEndPoint.searchItem.urlRequest(with: self.nutritionixConfiguration, queryItems: queryItems)
        let (data, _) = try await self.networkManager.make(request: request)
        return try self.networkManager.parseData(data: data)
    }
    ///Manages naturalNutrients endpoint request
    func naturalNutrientForCommonFoodWith<Item: Decodable>(parameters: NaturalNutrientsEndPointParameter) async throws -> Item {
        let bodyItems = NaturalNutrientsEndPointParameter.Keys.allCases.reduce(into: [:]) { body, key in
            body[key.rawValue] = parameters.getValueFor(key: key)
        }
        let request = try APIEndPoint.naturalNutrients.urlRequest(with: self.nutritionixConfiguration, body:bodyItems)
        let (data, _) = try await self.networkManager.make(request: request)
        return try self.networkManager.parseData(data: data)
    }
}
