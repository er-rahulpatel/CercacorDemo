//
//  SearchInstantEndPointResponseTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class SearchInstantEndPointResponseTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncodingDecoding() throws {
        // Given
        let commonFood = CommonFood(servingQuantity: 1.5,
                                    tagName: "Apple",
                                    photo: nil,
                                    tagId: "123",
                                    commonType: 1,
                                    foodName: "Apple",
                                    servingUnit: "piece",
                                    locale: "en_US")
        
        let brandedFood = BrandedFood(foodName: "Yogurt",
                                      servingUnit: "cup",
                                      nixBrandId: "456",
                                      brandNameItemName: "Chobani Yogurt",
                                      servingQuantity: 1.0,
                                      nfCalories: 150.0,
                                      photo: FoodItemThumbnail(thumb: ""),
                                      brandName: "Chobani",
                                      region: 1,
                                      brandType: 2,
                                      nixItemId: "789",
                                      locale: "en_US")
        
        let response = SearchInstantEndPointResponse(common: [commonFood], branded: [brandedFood])
        
        // When
        let encodedData = try JSONEncoder().encode(response)
        let decoded = try JSONDecoder().decode(SearchInstantEndPointResponse.self, from: encodedData)
        
        // Then
        XCTAssertEqual(decoded.common?.count, 1)
        XCTAssertEqual(decoded.branded?.count, 1)
        XCTAssertEqual(decoded.common?.first?.foodName, "Apple")
        XCTAssertEqual(decoded.branded?.first?.foodName, "Yogurt")
    }
    
    func testEncodingWithNilArrays() throws {
        // Given
        let response = SearchInstantEndPointResponse(common: nil, branded: nil)
        
        // When
        let encodedData = try JSONEncoder().encode(response)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
        
        // Then
        XCTAssertNil(jsonObject?["common"])
        XCTAssertNil(jsonObject?["branded"])
    }
    
    func testDecodingWithMissingArrays() throws {
        // Given
        let json = """
        {
            "common": null,
            "branded": []
        }
        """.data(using: .utf8)!
        
        // When
        let decoded = try JSONDecoder().decode(SearchInstantEndPointResponse.self, from: json)
        
        // Then
        XCTAssertNil(decoded.common)
        XCTAssertEqual(decoded.branded?.count, 0)
    }
    
    func testEquality() {
        // Given
        let response1 = SearchInstantEndPointResponse(common: [CommonFood](), branded: [BrandedFood]())
        let response2 = SearchInstantEndPointResponse(common: [CommonFood](), branded: [BrandedFood]())
        let response3 = SearchInstantEndPointResponse(common: nil, branded: nil)
        
        // Then
        XCTAssertEqual(response1, response2)
        XCTAssertNotEqual(response1, response3)
        XCTAssertNotEqual(response2, response3)
    }
    
}
