//
//  NutritionixConfigurationTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class NutritionixConfigurationTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSharedInstanceInitializationFromPlist() {
        // Given
        let bundle = Bundle(for: type(of: self))
        let plistPath = bundle.path(forResource: "Info", ofType: "plist") // Update with your plist name if different
        let infoDictionary = NSDictionary(contentsOfFile: plistPath!) as? [String: Any]
        let nutritionixInfo = infoDictionary?["Nutritionix"] as? [String: String]
        let expectedXAppId = nutritionixInfo?["xAppId"]
        let expectedXAppKey = nutritionixInfo?["xAppKey"]
        
        // When
        let configuration = NutritionixConfiguration.shared
        
        // Then
        XCTAssertEqual(configuration.xAppId, expectedXAppId)
        XCTAssertEqual(configuration.xAppKey, expectedXAppKey)
    }
    
    func testInitializationWithParameters() {
        // Given
        let xAppId = "testAppId"
        let xAppKey = "testAppKey"
        
        // When
        let configuration = NutritionixConfiguration(xAppId: xAppId, xAppKey: xAppKey)
        
        // Then
        XCTAssertEqual(configuration.xAppId, xAppId)
        XCTAssertEqual(configuration.xAppKey, xAppKey)
    }
    
    func testSingletonBehavior() {
        // Given
        let configuration1 = NutritionixConfiguration.shared
        
        // When
        let configuration2 = NutritionixConfiguration.shared
        
        // Then
        XCTAssertTrue(configuration1 === configuration2)
    }
}
