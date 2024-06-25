//
//  FoodItemDetailViewModelTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class FoodItemDetailViewModelTests: XCTestCase {
    var foodItemDetailViewModel_SUT: FoodItemDetailViewModel!
    var nutritionixAPIManagerMock: NutritionixAPIManagerMock!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.nutritionixAPIManagerMock = NutritionixAPIManagerMock(
            mockResponse: .failure(NetworkError.statusCodeUnavailable))
        let selectedNixItemId = "someTestId"
        self.foodItemDetailViewModel_SUT = FoodItemDetailViewModel(
            nutritionixAPIManager: self.nutritionixAPIManagerMock,
            selectedNixItemId: selectedNixItemId)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.nutritionixAPIManagerMock = nil
        self.foodItemDetailViewModel_SUT = nil
    }
    
    func testInitialization() {
        // Arrange
        let selectedNixItemId = "someTestId"
        
        // Act
        self.foodItemDetailViewModel_SUT = FoodItemDetailViewModel(
            nutritionixAPIManager: self.nutritionixAPIManagerMock, selectedNixItemId: selectedNixItemId)
        
        // Assert
        XCTAssertEqual(foodItemDetailViewModel_SUT.selectedNixItemId, selectedNixItemId)
        XCTAssertFalse(foodItemDetailViewModel_SUT.isError)
        XCTAssertEqual(foodItemDetailViewModel_SUT.errorMessage, "")
        XCTAssertNil(foodItemDetailViewModel_SUT.food)
        XCTAssertEqual(foodItemDetailViewModel_SUT.quantity, 0.0)
        XCTAssertTrue(foodItemDetailViewModel_SUT.nutrientsInfo.isEmpty)
    }
    
    func testSearchFoodItemByNixId_Success() {
        // Arrange
        let expectation = XCTestExpectation(description: "Search food item by NixId")
        self.nutritionixAPIManagerMock.mockResponse = .success(SearchItemEndPointResponseMock.successResponse)
        self.nutritionixAPIManagerMock = NutritionixAPIManagerMock(
            mockResponse: .success(SearchItemEndPointResponseMock.successResponse))
        
        // Act
        self.foodItemDetailViewModel_SUT.searchFoodItemByNixId("someTestId")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.foodItemDetailViewModel_SUT.food?.foodName, SearchItemEndPointResponseMock.successResponse.foods[0].foodName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
    
    func testSearchFoodItemByNixId_Failure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Search food item by NixId")
        nutritionixAPIManagerMock.mockResponse = .failure(NetworkError.invalidUrl)
        self.nutritionixAPIManagerMock = NutritionixAPIManagerMock(
            mockResponse: .failure(NetworkError.invalidUrl))
        
        // Act
        foodItemDetailViewModel_SUT.searchFoodItemByNixId("invalidTestId")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.foodItemDetailViewModel_SUT.isError)
            XCTAssertEqual(self.foodItemDetailViewModel_SUT.errorMessage, NetworkError.invalidUrl.description)
            XCTAssertNil(self.foodItemDetailViewModel_SUT.food)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0) // Adjust timeout as necessary
    }
    
    func testMapNutrientInformation() {
        // Arrange
        let food = SearchItemEndPointResponseMock.successResponse.foods[0]
        
        foodItemDetailViewModel_SUT.food = food
        
        // Act
        foodItemDetailViewModel_SUT.mapNutrientInformation()
        
        // Assert
        XCTAssertEqual(foodItemDetailViewModel_SUT.nutrientsInfo.count, 16)
        XCTAssertEqual(foodItemDetailViewModel_SUT.nutrientsInfo[0].name, "Protein")
        XCTAssertEqual(foodItemDetailViewModel_SUT.nutrientsInfo[1].name, "Total lipid (fat)")
        XCTAssertEqual(foodItemDetailViewModel_SUT.nutrientsInfo[0].amount, 3.0)
        XCTAssertEqual(foodItemDetailViewModel_SUT.nutrientsInfo[1].amount, 1.0)
    }
    
    func testSetQuantity() {
        // Act
        foodItemDetailViewModel_SUT.setQuantity(150.0)
        
        // Assert
        XCTAssertEqual(foodItemDetailViewModel_SUT.quantity, 150.0)
    }
    
    func testCalculateNutrientAmount() {
        // Arrange
        let amount = 30.0
        let servingQuantity = 300.0
        let defaultQuantity = 100.0
        
        // Act
        let calculatedAmount = foodItemDetailViewModel_SUT.calculateNutrientAmount(
            for: amount,
            servingQuantity: servingQuantity,
            defaultQuantity: defaultQuantity)
        
        // Assert
        XCTAssertEqual(calculatedAmount, 90.0) // (300/100) * 30 = 90
    }
    
} 
