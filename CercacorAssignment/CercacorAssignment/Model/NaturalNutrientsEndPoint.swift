//
//  NaturalNutrientsEndPoint.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-27.
//

import Foundation

struct NaturalNutrientsEndPointParameter {
    let query: String
    let ingredient_statement: Bool
    let include_subrecipe: Bool
    
    enum Keys: String, CaseIterable {
        case query
        case ingredient_statement
        case include_subrecipe
    }
    
    func getValueFor(key: Keys) -> String {
        switch key{
        case .query:
            return query
        case .ingredient_statement:
            return String(ingredient_statement)
        case .include_subrecipe:
            return String(include_subrecipe)
        }
    }
}

struct NaturalNutrientsEndPointResponse: Codable {
    var foods: [Food]
}
