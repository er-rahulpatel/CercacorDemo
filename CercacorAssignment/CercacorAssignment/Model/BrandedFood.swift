//
//  BrandedFood.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

struct BrandedFood: Codable, Equatable {
    let foodName: String
    var servingUnit: String
    let nixBrandId: String
    let brandNameItemName: String
    let servingQuantity: Double
    let nfCalories: Double
    let photo: FoodItemThumbnail
    let brandName: String
    let region: Int
    let brandType: Int
    let nixItemId: String
    let locale: String?
    
    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case servingUnit = "serving_unit"
        case nixBrandId = "nix_brand_id"
        case brandNameItemName = "brand_name_item_name"
        case servingQuantity = "serving_qty"
        case nfCalories = "nf_calories"
        case photo
        case brandName = "brand_name"
        case region
        case brandType = "brand_type"
        case nixItemId = "nix_item_id"
        case locale = "locale"
    }
    
    static func == (lhs: BrandedFood, rhs: BrandedFood) -> Bool {
        return lhs.foodName == rhs.foodName &&
        lhs.servingUnit == rhs.servingUnit &&
        lhs.nixBrandId == rhs.nixBrandId &&
        lhs.brandNameItemName == rhs.brandNameItemName &&
        lhs.servingQuantity == rhs.servingQuantity &&
        lhs.nfCalories == rhs.nfCalories &&
        lhs.photo == rhs.photo &&
        lhs.brandName == rhs.brandName &&
        lhs.region == rhs.region &&
        lhs.brandType == rhs.brandType &&
        lhs.nixItemId == rhs.nixItemId &&
        lhs.locale == rhs.locale
    }
}

struct FoodItemThumbnail: Codable, Equatable {
    public var thumb: String
    
    enum CodingKeys: String, CodingKey {
        case thumb
    }
}
