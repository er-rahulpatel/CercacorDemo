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
        let commonFood = CommonFood.getPreviewInitial()
        
        let brandedFood = BrandedFood.getPreviewInitial()
        
        let response = SearchInstantEndPointResponse(common: [commonFood], branded: [brandedFood])
        
        // When
        let encodedData = try JSONEncoder().encode(response)
        let decoded = try JSONDecoder().decode(SearchInstantEndPointResponse.self, from: encodedData)
        
        // Then
        XCTAssertEqual(decoded.common?.count, 1)
        XCTAssertEqual(decoded.branded?.count, 1)
        XCTAssertEqual(decoded.common?.first?.foodName, "Test Food")
        XCTAssertEqual(decoded.branded?.first?.foodName, "Hamburger")
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
