//
//  CommonFood.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

struct CommonFood: Codable {
    let commonType: Int?
    let servingQuantity: Double
    let tagName: String
    let fullNutrients: [FullNutrient]?
    let photo: FoodItemThumbnail
    let tagId: String
    let foodName: String
    let servingUnit: String
    let locale: String?
    let nfCalories: Double
    
    enum CodingKeys: String, CodingKey {
        case servingQuantity = "serving_qty"
        case tagName = "tag_name"
        case fullNutrients = "full_nutrients"
        case photo = "photo"
        case tagId = "tag_id"
        case commonType = "common_type"
        case foodName = "food_name"
        case servingUnit = "serving_unit"
        case locale = "locale"
        case nfCalories
    }
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        servingQuantity = try container.decode(Double.self, forKey: .servingQuantity)
        tagName = try container.decode(String.self, forKey: .tagName)
        fullNutrients = try? container.decode([FullNutrient].self, forKey: .fullNutrients)
        photo = try container.decode(FoodItemThumbnail.self, forKey: .photo)
        tagId = try container.decode(String.self, forKey: .tagId)
        commonType = try? container.decode(Int.self, forKey: .commonType)
        foodName = try container.decode(String.self, forKey: .foodName)
        servingUnit = try container.decode(String.self, forKey: .servingUnit)
        locale = try container.decode(String.self, forKey: .locale)
        nfCalories = (fullNutrients?.first(where: { $0.attributeId == 208 })? .amount ?? 0)
    }
}

extension CommonFood: Equatable {
    static func == (lhs: CommonFood, rhs: CommonFood) -> Bool {
        return lhs.servingQuantity == rhs.servingQuantity &&
        lhs.tagName == rhs.tagName &&
        lhs.fullNutrients == rhs.fullNutrients &&
        lhs.photo == rhs.photo &&
        lhs.tagId == rhs.tagId &&
        lhs.commonType == rhs.commonType &&
        lhs.foodName == rhs.foodName &&
        lhs.servingUnit == rhs.servingUnit &&
        lhs.locale == rhs.locale &&
        lhs.nfCalories == rhs.nfCalories
    }
}
