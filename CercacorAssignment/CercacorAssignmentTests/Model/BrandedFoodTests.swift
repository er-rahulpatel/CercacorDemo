//
//  BrandedFoodTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class BrandedFoodTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncodingDecoding() throws {
        // Given
        let original = BrandedFood(foodName: "Yogurt",
                                   servingUnit: "cup",
                                   nixBrandId: "123",
                                   brandNameItemName: "Chobani Yogurt",
                                   servingQuantity: 1.0,
                                   nfCalories: 150.0,
                                   photo: FoodItemThumbnail(thumb: "https://example.com/yogurt.jpg"),
                                   brandName: "Chobani",
                                   region: 1,
                                   brandType: 2,
                                   nixItemId: "456",
                                   locale: "en_US")
        
        // When
        let encodedData = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BrandedFood.self, from: encodedData)
        
        // Then
        XCTAssertEqual(decoded, original)
    }
    
    func testEncodingWithNilValues() throws {
        // Given
        let original = BrandedFood(foodName: "Granola Bar",
                                   servingUnit: "bar",
                                   nixBrandId: "789",
                                   brandNameItemName: "Nature Valley Granola Bar",
                                   servingQuantity: 1.0,
                                   nfCalories: 200.0,
                                   photo: FoodItemThumbnail(thumb: "https://example.com/granola.jpg"),
                                   brandName: "Nature Valley",
                                   region: 2,
                                   brandType: 1,
                                   nixItemId: "321",
                                   locale: nil)
        
        // When
        let encodedData = try JSONEncoder().encode(original)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
        
        // Then
        XCTAssertNil(jsonObject?["locale"])
    }
    
    func testDecodingWithMissingKeys() throws {
        // Given
        let json = """
        {
            "food_name": "Cereal",
            "serving_unit": "bowl",
            "nix_brand_id": "987",
            "brand_name_item_name": "Kellogg's Cereal",
            "serving_qty": 1.5,
            "nf_calories": 180.0,
            "photo": {"thumb": "https://example.com/cereal.jpg"},
            "brand_name": "Kellogg's",
            "region": 1,
            "brand_type": 1,
            "nix_item_id": "654"
        }
        """.data(using: .utf8)!
        
        // When
        let decoded = try JSONDecoder().decode(BrandedFood.self, from: json)
        
        // Then
        XCTAssertEqual(decoded.foodName, "Cereal")
        XCTAssertEqual(decoded.servingUnit, "bowl")
        XCTAssertEqual(decoded.nixBrandId, "987")
        XCTAssertEqual(decoded.brandNameItemName, "Kellogg's Cereal")
        XCTAssertEqual(decoded.servingQuantity, 1.5)
        XCTAssertEqual(decoded.nfCalories, 180.0)
        XCTAssertEqual(decoded.photo, FoodItemThumbnail(thumb: "https://example.com/cereal.jpg"))
        XCTAssertEqual(decoded.brandName, "Kellogg's")
        XCTAssertEqual(decoded.region, 1)
        XCTAssertEqual(decoded.brandType, 1)
        XCTAssertEqual(decoded.nixItemId, "654")
        XCTAssertNil(decoded.locale)
    }
    
    func testEquality() {
        // Given
        let brandedFood1 = BrandedFood(foodName: "Pasta",
                                       servingUnit: "plate",
                                       nixBrandId: "111",
                                       brandNameItemName: "Barilla Pasta",
                                       servingQuantity: 2.0,
                                       nfCalories: 220.0,
                                       photo: FoodItemThumbnail(thumb: "https://example.com/pasta.jpg"),
                                       brandName: "Barilla",
                                       region: 2,
                                       brandType: 2,
                                       nixItemId: "222",
                                       locale: "it_IT")
        
        let brandedFood2 = BrandedFood(foodName: "Pasta",
                                       servingUnit: "plate",
                                       nixBrandId: "111",
                                       brandNameItemName: "Barilla Pasta",
                                       servingQuantity: 2.0,
                                       nfCalories: 220.0,
                                       photo: FoodItemThumbnail(thumb: "https://example.com/pasta.jpg"),
                                       brandName: "Barilla",
                                       region: 2,
                                       brandType: 2,
                                       nixItemId: "222",
                                       locale: "it_IT")
        
        let brandedFood3 = BrandedFood(foodName: "Rice",
                                       servingUnit: "bowl",
                                       nixBrandId: "333",
                                       brandNameItemName: "Uncle Ben's Rice",
                                       servingQuantity: 1.5,
                                       nfCalories: 180.0,
                                       photo: FoodItemThumbnail(thumb: "https://example.com/rice.jpg"),
                                       brandName: "Uncle Ben's",
                                       region: 1,
                                       brandType: 1,
                                       nixItemId: "444",
                                       locale: "en_US")
        
        // Then
        XCTAssertEqual(brandedFood1, brandedFood2)
        XCTAssertNotEqual(brandedFood1, brandedFood3)
        XCTAssertNotEqual(brandedFood2, brandedFood3)
    }
    
    func testThumbnailEncodingDecoding() throws {
        // Given
        let original = FoodItemThumbnail(thumb: "https://example.com/food.jpg")
        
        // When
        let encodedData = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(FoodItemThumbnail.self, from: encodedData)
        
        // Then
        XCTAssertEqual(decoded, original)
    }
    
    func testThumbnailEquality() {
        // Given
        let thumbnail1 = FoodItemThumbnail(thumb: "https://example.com/image1.jpg")
        let thumbnail2 = FoodItemThumbnail(thumb: "https://example.com/image1.jpg")
        let thumbnail3 = FoodItemThumbnail(thumb: "https://example.com/image2.jpg")
        
        // Then
        XCTAssertEqual(thumbnail1, thumbnail2)
        XCTAssertNotEqual(thumbnail1, thumbnail3)
    }
}
