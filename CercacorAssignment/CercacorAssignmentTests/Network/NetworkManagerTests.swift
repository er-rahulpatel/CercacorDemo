//
//  NetworkManagerTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class NetworkManagerTests: XCTestCase {
    var networkManager_SUT: NetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.networkManager_SUT = NetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.networkManager_SUT = nil
    }
    
    func testMakeRequest_Success() {
        // Arrange
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Make request")
        
        Task {
            do {
                let (data, urlResponse) = try await self.networkManager_SUT.make(request: request)
                XCTAssertNotNil(data)
                XCTAssertNotNil(urlResponse)
                XCTAssertTrue(urlResponse is HTTPURLResponse)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
    
    func testParseData_Success() {
        // Arrange
        let json = """
                {
                    "name": "Test Item",
                    "quantity": 10
                }
                """
        let jsonData = json.data(using: .utf8)!
        
        // Act
        do {
            let parsedData: TestItem = try networkManager_SUT.parseData(data: jsonData)
            
            // Assert
            XCTAssertEqual(parsedData.name, "Test Item")
            XCTAssertEqual(parsedData.quantity, 10)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testMakeRequest_Failure() {
        // Arrange
        let url = URL(string: "https://trackapi.nutritionix.com/v2")!
        let request = URLRequest(url: url)
        
        // Act & Assert
        let expectation = XCTestExpectation(description: "Make request")
        
        Task {
            do {
                _ = try await self.networkManager_SUT.make(request: request)
                XCTFail("Expected error to be thrown.")
            } catch NetworkError.APIError(let error) {
                XCTAssertEqual(error, ResponseError.resourceNotFound)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary
    }
}

// Example Codable struct for testing purposes
struct TestItem: Codable {
    let name: String
    let quantity: Int
}
