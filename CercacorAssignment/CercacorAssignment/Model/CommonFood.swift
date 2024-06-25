//
//  CommonFood.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

struct CommonFood: Codable, Equatable {
    let servingQuantity: Double
    let tagName: String
    let photo: FoodItemThumbnail?
    let tagId: String
    let commonType: Int?
    let foodName: String
    var servingUnit: String
    let locale: String?
    
    enum CodingKeys: String, CodingKey {
        case servingQuantity = "serving_qty"
        case tagName = "tag_name"
        case photo = "photo"
        case tagId = "tag_id"
        case commonType = "common_type"
        case foodName = "food_name"
        case servingUnit = "serving_unit"
        case locale = "locale"
    }
}

