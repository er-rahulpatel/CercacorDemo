//
//  FoodItemListViewModelTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
import Combine
@testable import CercacorAssignment

final class FoodItemListViewModelTests: XCTestCase {
    private var foodItemListViewModel_SUT: FoodItemListViewModel!
    private var nutritionixAPIManagerMock: NutritionixAPIManagerMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.nutritionixAPIManagerMock = NutritionixAPIManagerMock(
            mockResponse: .failure(SearchInstantEndPointResponseMock.failureResponse))
        self.foodItemListViewModel_SUT = FoodItemListViewModel(
            nutritionixAPIManager: self.nutritionixAPIManagerMock)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.foodItemListViewModel_SUT = nil
        self.nutritionixAPIManagerMock = nil
    }
    
    func testInitialization() {
        XCTAssertNotNil(foodItemListViewModel_SUT.nutritionixAPIManager)
        XCTAssertTrue(foodItemListViewModel_SUT.foodItems.isEmpty)
        XCTAssertFalse(foodItemListViewModel_SUT.isError)
        XCTAssertEqual(foodItemListViewModel_SUT.errorMessage, "")
        XCTAssertNil(foodItemListViewModel_SUT.selectedItemIndex)
        XCTAssertEqual(foodItemListViewModel_SUT.searchText, "")
        XCTAssertFalse(foodItemListViewModel_SUT.showListView)
    }
    
    func testSearchTextSetter() {
        self.foodItemListViewModel_SUT.searchText = "apple"
        XCTAssertTrue(self.foodItemListViewModel_SUT.showListView)
        
        self.foodItemListViewModel_SUT.searchText = "a"
        XCTAssertFalse(self.foodItemListViewModel_SUT.showListView)
    }
    
    func testSearchInstantFoodItem_Success() {
        // Arrange
        let expectation = XCTestExpectation(description: "Search food items")
        self.nutritionixAPIManagerMock.mockResponse = .success(SearchInstantEndPointResponseMock.successResponse)
        ///Initilizing again because above ref passing doesn't work
        self.foodItemListViewModel_SUT = FoodItemListViewModel(nutritionixAPIManager: self.nutritionixAPIManagerMock)
        
        // Act
        self.foodItemListViewModel_SUT.searchInstantFoodItem(for: "Bun")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.foodItemListViewModel_SUT.foodItems.count, SearchInstantEndPointResponseMock.successResponse.branded?.count ?? 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0) // Adjust timeout as necessary
    }
    
    func testSearchInstantFoodItem_Failure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Search food items")
        self.nutritionixAPIManagerMock.mockResponse = .failure(SearchInstantEndPointResponseMock.failureResponse)
        ///Initilizing again because above ref passing doesn't work
        self.foodItemListViewModel_SUT = FoodItemListViewModel(nutritionixAPIManager: self.nutritionixAPIManagerMock)
        
        // Act
        self.foodItemListViewModel_SUT.searchInstantFoodItem(for: "orange")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.foodItemListViewModel_SUT.isError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0) // Adjust timeout as necessary
    }
    
    func testHandleError() {
        let mockError = NetworkError.APIError(.resourceNotFound)
        self.foodItemListViewModel_SUT.handleError(mockError)
        
        XCTAssertTrue(foodItemListViewModel_SUT.isError)
        XCTAssertEqual(foodItemListViewModel_SUT.errorMessage, mockError.description)
    }
    
    func testGetNixItemId_ValidIndex() throws {
        let mockItem = BrandedFood.getPreviewInitial()
        foodItemListViewModel_SUT.foodItems = [mockItem]
        
        XCTAssertEqual(foodItemListViewModel_SUT.getNixItemId(for: 0), BrandedFood.getPreviewInitial().nixItemId)
    }
    
    func testGetNixItemId_InvalidIndex() throws {
        XCTAssertNil(foodItemListViewModel_SUT.getNixItemId(for: 0))
    }
    
    func testSearchText_Empty() throws {
        foodItemListViewModel_SUT.searchText = ""
        XCTAssertFalse(foodItemListViewModel_SUT.showListView)
    }
    
    func testSearchText_CharCountExact() throws {
        foodItemListViewModel_SUT.searchText = "abc"
        XCTAssertTrue(foodItemListViewModel_SUT.showListView)
    }
    
    func testSearchText_CharCountLessThan() throws {
        foodItemListViewModel_SUT.searchText = "ab"
        XCTAssertFalse(foodItemListViewModel_SUT.showListView)
    }
    
}


