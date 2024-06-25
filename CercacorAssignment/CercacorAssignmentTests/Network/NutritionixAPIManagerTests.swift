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
    
    func testGetFoodItemsByInstantSearch_Success() {
        // Arrange
        let query = "Bun"
        let expectedDataResponse = SearchInstantEndPointResponseMock.successDataResponse
        let expectedResponse = SearchInstantEndPointResponseMock.successResponse
        
        // Mock the network response
        networkManagerMock.data = expectedDataResponse
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Get food items by instant search")
        
        Task {
            do {
                let response: SearchInstantEndPointResponse = try await self.nutritionixAPIManager_SUT.getFoodItemsByInstantSearch(query: query)
                
                XCTAssertEqual(response.branded?.count, expectedResponse.branded?.count)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
    
    func testGetFoodItemsByNixId_Success() {
        // Arrange
        let nixId = "12345"
        let expectedDataResponse = SearchItemEndPointResponseMock.successDataResponse
        let expectedResponse = SearchItemEndPointResponseMock.successResponse // Define your mock data
        
        // Mock the network response
        networkManagerMock.data = expectedDataResponse
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Get food items by Nix Id")
        
        Task {
            do {
                let response: SearchItemEndPointResponse = try await self.nutritionixAPIManager_SUT.getFoodItemsByNixId(nixId)
                
                XCTAssertEqual(response.foods.count, expectedResponse.foods.count)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
}
