//
//  NutritionixConfiguration.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

class NutritionixConfiguration {
    static let shared = NutritionixConfiguration()
    let xAppId: String
    let xAppKey: String
    
    private init() {
        guard let configuration = Bundle.main.infoDictionary?["Nutritionix"] as? [String: String],
              let xAppId = (configuration["xAppId"]),
              let xAppKey = configuration["xAppKey"]
                
        else { fatalError("Nutritionix info not found in plist") }
        
        self.xAppId = xAppId
        self.xAppKey = xAppKey
    }
    
    init(xAppId: String, xAppKey: String) {
        self.xAppId = xAppId
        self.xAppKey = xAppKey
    }
}
