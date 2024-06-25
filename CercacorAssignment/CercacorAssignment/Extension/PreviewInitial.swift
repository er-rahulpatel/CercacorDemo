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

extension BrandedFood: PreviewIntialHandler {
    typealias Element = BrandedFood
    static func getPreviewInitial() -> BrandedFood {
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


