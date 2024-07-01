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
    
    func testDecodeFromJSON() throws {
            // Given
            let json = """
            {
                "serving_qty": 1.5,
                "tag_name": "Test Food",
                "full_nutrients": [
                    {"attr_id": 208, "value": 150}
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
            
            // When
            let decoder = JSONDecoder()
            let commonFood = try decoder.decode(CommonFood.self, from: json)
            
            // Then
            XCTAssertEqual(commonFood.servingQuantity, 1.5)
            XCTAssertEqual(commonFood.tagName, "Test Food")
            XCTAssertNotNil(commonFood.fullNutrients)
            XCTAssertEqual(commonFood.fullNutrients?.count, 1)
            XCTAssertEqual(commonFood.photo.thumb, "https://example.com/thumb.jpg")
            XCTAssertEqual(commonFood.tagId, "abc123")
            XCTAssertEqual(commonFood.commonType, 1)
            XCTAssertEqual(commonFood.foodName, "Test Food")
            XCTAssertEqual(commonFood.servingUnit, "cup")
            XCTAssertEqual(commonFood.locale, "en_US")
            XCTAssertEqual(commonFood.nfCalories, 150)
        }
}
