//
//  Food.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-22.
//

import Foundation

struct Food: Codable {
    let foodName: String
    let brandName: String?
    let servingQuantity: Double
    let servingUnit: String
    let servingWeightGrams: Double?
    let metricQuantity: Double?
    let metricUOM: String?
    let calories: Double
    let totalFat: Double?
    let saturatedFat: Double?
    let transFat: Double?
    let cholesterol: Double?
    let calcium: Double?
    let sodium: Double?
    let totalCarbohydrate: Double?
    let dietaryFiber: Double?
    let sugars: Double?
    let protein: Double?
    let potassium: Double?
    let fullNutrients: [FullNutrient]?
    let nixBrandName: String?
    let nixBrandId: String?
    let nixItemName: String?
    let nixItemId: String
    let source: Int?
    let altMeasures: [FoodItemMeasure]?
    let photo: FoodItemThumbnail?
    let ingredients: String?
    
    
    enum CodingKeys : String, CodingKey {
        case foodName = "food_name"
        case brandName = "brand_name"
        case servingQuantity = "serving_qty"
        case servingUnit = "serving_unit"
        case servingWeightGrams  = "serving_weight_grams"
        case metricQuantity = "nf_metric_qty"
        case metricUOM = "nf_metric_uom"
        case calories = "nf_calories"
        case totalFat = "nf_total_fat"
        case saturatedFat = "nf_saturated_fat"
        case transFat = "nf_trans_fatty_acid"
        case cholesterol = "nf_cholesterol"
        case calcium = "nf_calcium_mg"
        case sodium = "nf_sodium"
        case totalCarbohydrate = "nf_total_carbohydrate"
        case dietaryFiber = "nf_dietary_fiber"
        case sugars = "nf_sugars"
        case protein = "nf_protein"
        case potassium = "nf_potassium"
        case fullNutrients = "full_nutrients"
        case nixBrandName = "nix_brand_name"
        case nixBrandId = "nix_brand_id"
        case nixItemName = "nix_item_name"
        case nixItemId = "nix_item_id"
        case source
        case altMeasures = "alt_measures"
        case photo
        case ingredients = "nf_ingredient_statement"
    }
}

struct FoodItemMeasure: Codable {
    let measure: String
    let quantity: Double
    let seq: Double?
    let servingWeight: Double?
    
    enum CodingKeys: String, CodingKey {
        case measure
        case quantity = "qty"
        case seq
        case servingWeight = "serving_weight"
    }
}

struct FullNutrient: Codable {
    let attributeId: Int
    let amount: Double
    
    enum CodingKeys : String, CodingKey {
        case attributeId = "attr_id"
        case amount = "value"
    }
}

struct NutrientMap: Codable {
    let attributeId: Int
    let name: String
    let unit: String
    
    enum CodingKeys : String, CodingKey {
        case attributeId = "attr_id"
        case name
        case unit
    }
}

struct NutrientInfo {
    let attributeId: Int
    var amount: Double
    let name: String
    let unit: String
    
    /// Update nutrient amount in current nutrient information
    func updateAmount(_ amount: Double) -> Self {
        var nutrientInfo = self
        nutrientInfo.amount = amount
        return nutrientInfo
    }
}
