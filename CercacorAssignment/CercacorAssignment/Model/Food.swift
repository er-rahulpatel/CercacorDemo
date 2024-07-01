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
    var fullNutrients: [FullNutrient]?
    let nixBrandName: String?
    let nixBrandId: String?
    let nixItemName: String?
    let nixItemId: String?
    let source: Int?
    let altMeasures: [FoodItemMeasure]?
    let photo: FoodItemThumbnail?
    let subRecipes: [SubRecipe]?
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
        case subRecipes = "sub_recipe"
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

struct SubRecipe: Codable {
    var servingWeight: Double?
    let foodName: String
    let ndbNumber: Int
    var calories: Double
    let tagId: Int
    let recipeId: Int
    var servingQuantity: Double
    let servingUnit: String?
    var foodDetail: Food?
    
    enum CodingKeys: String, CodingKey {
        case servingWeight = "serving_weight"
        case foodName = "food"
        case ndbNumber = "ndb_number"
        case calories
        case tagId = "tag_id"
        case recipeId = "recipe_id"
        case servingQuantity = "serving_qty"
        case servingUnit = "serving_unit"
    }
    
    private func findMatchingMeasure() -> FoodItemMeasure? {
        return self.foodDetail?.altMeasures?.first(where: {
            (self.servingUnit == $0.measure) ||
            Measures.getInstanceByAbbreviation(self.servingUnit ?? "") ==  Measures.getInstanceByAbbreviation($0.measure)
        })
    }
    
    private func scaleFactorForMatchingMeasure () -> Double? {
        if let foodMeasure = self.findMatchingMeasure(),
           let foodDetail = self.foodDetail {
            return ((foodMeasure.servingWeight ?? 0) / foodMeasure.quantity) / ((foodDetail.servingWeightGrams ?? 1) / foodDetail.servingQuantity)
        }
        return nil
    }
    
    func adjustSubRecipeNutrientsWithServingUnit() -> SubRecipe {
        
        guard let subRecipeFoodDetail = self.foodDetail,
              let subRecipeServingUnit = self.servingUnit,
              let scaleFactor = self.scaleFactorForMatchingMeasure(),
              Measures.getInstanceByAbbreviation(subRecipeServingUnit) != Measures.getInstanceByAbbreviation(subRecipeFoodDetail.servingUnit)
        else { return self }
        
        var updatedSubRecipe = self
        updatedSubRecipe.foodDetail?.fullNutrients?.updateEach {  $0.amount *= scaleFactor }
        return updatedSubRecipe
    }
}

struct FullNutrient: Codable, Equatable {
    let attributeId: Int
    var amount: Double
    
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
}

enum Measures: CaseIterable {
    case grams, milligrams, ounces, pounds, fluidOunces, teaspoons, tablespoons, quarts, cups, liters, milliliters
    
    var abbreviation: String{
        switch self {
        case .grams:
            return "g"
        case .milligrams:
            return "mg"
        case .ounces:
            return "oz"
        case .pounds:
            return "lb"
        case .fluidOunces:
            return "fl oz"
        case .teaspoons:
            return "tsp"
        case .tablespoons:
            return "tbsp"
        case .quarts:
            return "quart"
        case .cups:
            return "cup"
        case .liters:
            return "L"
        case .milliliters:
            return "mL"
        }
    }
    static func getInstanceByAbbreviation(_ abbreviation: String) -> Measures?{
        let formattedArgument = abbreviation.components(separatedBy: .punctuationCharacters).joined().filter{!$0.isWhitespace}.lowercased()
        return Measures.allCases.first(where: {$0.validAbbreviationsformatted.contains( formattedArgument)})
    }
    var validAbbreviationsformatted: [String]{
        var result: [String]
        switch self {
        case .grams:
            result = ["g", "gram", "grams"]
        case .ounces:
            result = ["oz", "wt. oz"]
        case .fluidOunces:
            return ["fluid ounces", "fl oz", "fluid ozunce", "fluid oz", "fl ounce", "fl ounces"]
        case .teaspoons:
            return ["tsp","tsps","teaspoon","teaspoons"]
        case .tablespoons:
            return ["tbsp", "tbsps", "tablespoon", "tablespoons"]
        case .quarts:
            return ["quart", "quarts", "qt", "qts"]
        case .cups:
            return ["cup", "cups", "c"]
        case .liters:
            return ["l", "liter", "liters", "litre", "litres"]
        case .milliliters:
            return ["ml", "milliliter", "milliliters"]
        default:
            result = [self.abbreviation]
        }
        return result.map{$0.components(separatedBy: .punctuationCharacters).joined().filter{!$0.isWhitespace}.lowercased()}
    }
}
