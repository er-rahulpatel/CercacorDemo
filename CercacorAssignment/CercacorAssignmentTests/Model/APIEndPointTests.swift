//
//  APIEndPointTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class APIEndPointTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testURLRequestCreation() {
        // Given
        let configuration = NutritionixConfiguration(xAppId: "testAppId", xAppKey: "testAppKey")
        let endPoint = APIEndPoint.searchItem
        let queryItems = [URLQueryItem(name: "query", value: "apple")]
        let body: [String: AnyHashable]? = nil
        
        // When
        do {
            let request = try endPoint.urlRequest(with: configuration, queryItems: queryItems, body: body)
            
            // Then
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url?.query, "query=apple")
        } catch {
            XCTFail("Failed to create URLRequest: \(error)")
        }
    }
}
