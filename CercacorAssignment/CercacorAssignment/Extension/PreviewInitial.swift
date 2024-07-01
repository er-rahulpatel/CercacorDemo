//
//  PreviewInitial.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-21.
//

import Foundation

///To manage preview initial in UI
protocol PreviewIntialHandler {
    associatedtype Element
    static func getPreviewInitial() -> Element
}

extension CommonFood: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        let json = """
        {
            "serving_qty": 1.5,
            "tag_name": "Test Food",
            "full_nutrients": [
                {"attribute_id": 208, "value": 150}
            ],
            "photo": {"url": "https://example.com/image.jpg", "thumb": "https://example.com/thumb.jpg"},
            "tag_id": "abc123",
            "common_type": 1,
            "food_name": "Test Food",
            "serving_unit": "cup",
            "locale": "en_US",
            "nfCalories": 150
        }
        """.data(using: .utf8)!
        
        return try! JSONDecoder().decode(CommonFood.self, from: json)
    }
}

extension BrandedFood: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        BrandedFood(
            foodName: "Hamburger",
            servingUnit: "sandwich",
            nixBrandId: "58c05bd9fc977da756c7a4fc",
            brandNameItemName: "Milo's Hamburgers Hamburger",
            servingQuantity: 1,
            nfCalories: 340,
            photo: FoodItemThumbnail.getPreviewInitial(),
            brandName: "Milo's Hamburgers",
            region: 1,
            brandType: 1,
            nixItemId: "c6405291f1393db78caf5a7e",
            locale: "en_US"
        )
    }
}

extension FoodItemThumbnail: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        FoodItemThumbnail(
            thumb: "https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png"
        )
    }
}

extension FoodItemDisplay: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        FoodItemDisplay(
            thumbnail: "https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png",
            name: "Hamburger",
            calories: 340)
    }
}

extension FullNutrient: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        FullNutrient(attributeId: 301, amount: 50)
    }
}

extension NutrientInfo: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        NutrientInfo(
            attributeId: 301,
            amount: 50,
            name: "Calcium",
            unit: "mg")
    }
}

extension SubRecipe: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        SubRecipe(
            foodName: "Hamburger",
            ndbNumber: 13424,
            calories: 50,
            tagId: 12,
            recipeId: 124,
            servingQuantity: 4,
            servingUnit: "g")
    }
}

extension SearchInstantEndPointResponse: PreviewIntialHandler {
    typealias Element = Self
    static func getPreviewInitial() -> Self {
        SearchInstantEndPointResponse(common: [CommonFood.getPreviewInitial()], branded: [BrandedFood.getPreviewInitial()])
    }
}
