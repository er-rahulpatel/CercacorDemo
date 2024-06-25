//
//  CommonFoodTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class CommonFoodTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncodingDecoding() throws {
        // Given
        let original = CommonFood(servingQuantity: 1.5,
                                  tagName: "Apple",
                                  photo: nil,
                                  tagId: "123",
                                  commonType: 1,
                                  foodName: "Apple",
                                  servingUnit: "piece",
                                  locale: "en_US")
        
        // When
        let encodedData = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CommonFood.self, from: encodedData)
        
        // Then
        XCTAssertEqual(decoded.servingQuantity, original.servingQuantity)
        XCTAssertEqual(decoded.tagName, original.tagName)
        XCTAssertEqual(decoded.photo, original.photo)
        XCTAssertEqual(decoded.tagId, original.tagId)
        XCTAssertEqual(decoded.commonType, original.commonType)
        XCTAssertEqual(decoded.foodName, original.foodName)
        XCTAssertEqual(decoded.servingUnit, original.servingUnit)
        XCTAssertEqual(decoded.locale, original.locale)
    }
    
    func testEncodingWithNilValues() throws {
        // Given
        let original = CommonFood(servingQuantity: 2.0,
                                  tagName: "Banana",
                                  photo: nil,
                                  tagId: "456",
                                  commonType: nil,
                                  foodName: "Banana",
                                  servingUnit: "piece",
                                  locale: nil)
        
        // When
        let encodedData = try JSONEncoder().encode(original)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
        
        // Then
        XCTAssertNil(jsonObject?["photo"])
        XCTAssertNil(jsonObject?["common_type"])
        XCTAssertNil(jsonObject?["locale"])
    }
    
    func testDecodingWithMissingKeys() throws {
        // Given
        let json = """
        {
            "serving_qty": 3.0,
            "tag_name": "Orange",
            "tag_id": "789",
            "food_name": "Orange",
            "serving_unit": "piece"
        }
        """.data(using: .utf8)!
        
        // When
        let decoded = try JSONDecoder().decode(CommonFood.self, from: json)
        
        // Then
        XCTAssertEqual(decoded.servingQuantity, 3.0)
        XCTAssertEqual(decoded.tagName, "Orange")
        XCTAssertNil(decoded.photo)
        XCTAssertEqual(decoded.tagId, "789")
        XCTAssertNil(decoded.commonType)
        XCTAssertEqual(decoded.foodName, "Orange")
        XCTAssertEqual(decoded.servingUnit, "piece")
        XCTAssertNil(decoded.locale)
    }
    
    func testRoundTrip() throws {
        // Given
        let original = CommonFood(servingQuantity: 1.0,
                                  tagName: "Mango",
                                  photo: FoodItemThumbnail(thumb:"https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png"),
                                  tagId: "321",
                                  commonType: 2,
                                  foodName: "Mango",
                                  servingUnit: "piece",
                                  locale: "en_GB")
        
        // When
        let encodedData1 = try JSONEncoder().encode(original)
        let decoded1 = try JSONDecoder().decode(CommonFood.self, from: encodedData1)
        let encodedData2 = try JSONEncoder().encode(decoded1)
        let decoded2 = try JSONDecoder().decode(CommonFood.self, from: encodedData2)
        
        // Then
        XCTAssertEqual(decoded1, decoded2)
    }
}
