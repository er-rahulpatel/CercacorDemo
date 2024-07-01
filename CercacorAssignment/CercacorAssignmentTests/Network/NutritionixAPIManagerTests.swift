//
//  NutritionixAPIManagerTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class NutritionixAPIManagerTests: XCTestCase {
    
    var nutritionixAPIManager_SUT: NutritionixAPIManager!
    var networkManagerMock: NetworkManagerMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManagerMock = NetworkManagerMock()
        let nutritionixConfiguration = NutritionixConfiguration(xAppId: "", xAppKey: "")
        self.nutritionixAPIManager_SUT = NutritionixAPIManager(nutritionixConfiguration: nutritionixConfiguration, networkManager: networkManagerMock)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.nutritionixAPIManager_SUT = nil
        self.networkManagerMock = nil
    }
    
    func testSearchInstantFoodItems_Success() {
        // Arrange
        let parameters = SearchInstantEndPointParameter(query: "Bun", common: true, branded: true, detailed: true)
        let expectedDataResponse = SearchInstantEndPointResponseMock.successDataResponse
        let expectedResponse = SearchInstantEndPointResponseMock.successResponse
        
        // Mock the network response
        networkManagerMock.data = expectedDataResponse
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Get food items by instant search")
        
        Task {
            do {
                let response: SearchInstantEndPointResponse = try await self.nutritionixAPIManager_SUT.searchInstantFoodItemsWith(parameters: parameters)
                
                XCTAssertEqual(response.branded?.count, expectedResponse.branded?.count)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
    
    func testSearchItemForBrandedFood_Success() {
        // Arrange
        let parameters = SearchItemEndPointParameter(nix_item_id: "12345")
        let expectedDataResponse = SearchItemEndPointResponseMock.successDataResponse
        let expectedResponse = SearchItemEndPointResponseMock.successResponse // Define your mock data
        
        // Mock the network response
        networkManagerMock.data = expectedDataResponse
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Get food items by Nix Id")
        
        Task {
            do {
                let response: SearchItemEndPointResponse = try await self.nutritionixAPIManager_SUT.searchItemForBrandedFoodWith(parameters: parameters)
                
                XCTAssertEqual(response.foods.count, expectedResponse.foods.count)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
}
