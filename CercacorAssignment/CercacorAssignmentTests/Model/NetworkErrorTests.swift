//
//  NetworkErrorTests.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import XCTest
@testable import CercacorAssignment

final class NetworkErrorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDescription() {
        XCTAssertEqual(NetworkError.configurationError.description, "Configuration error")
        XCTAssertEqual(NetworkError.invalidUrl.description, "Invalid URL")
        
        let apiError = NetworkError.APIError(.forbidden)
        XCTAssertEqual(apiError.description, ResponseError.forbidden.description)
        
        XCTAssertEqual(NetworkError.statusCodeUnavailable.description, "Invalid response")
    }
    
    func testAPIErrorInitialization() {
        let responseError = ResponseError.internalServerError
        let apiError = NetworkError.APIError(responseError)
        XCTAssertEqual(apiError.description, responseError.description)
    }
    
    func testStatusCode() {
        XCTAssertEqual(ResponseError.invalidRequest.statusCode, 400)
        XCTAssertEqual(ResponseError.unauthorized.statusCode, 401)
        XCTAssertEqual(ResponseError.forbidden.statusCode, 403)
        XCTAssertEqual(ResponseError.resourceNotFound.statusCode, 404)
        XCTAssertEqual(ResponseError.resourceAlreadyExists.statusCode, 409)
        XCTAssertEqual(ResponseError.internalServerError.statusCode, 500)
    }
    
    func testResponseErrorDescription() {
        XCTAssertEqual(ResponseError.invalidRequest.description, "Validation Error, Invalid input parameters, Invalid request")
        XCTAssertEqual(ResponseError.unauthorized.description, "Unauthorized, Invalid auth keys, Usage limits exceeded, Missing tokens")
        XCTAssertEqual(ResponseError.forbidden.description, "Forbidden, Disallowed entity")
        XCTAssertEqual(ResponseError.resourceNotFound.description, "Resource not found")
        XCTAssertEqual(ResponseError.resourceAlreadyExists.description, "Resource conflict, Resource already exists")
        XCTAssertEqual(ResponseError.internalServerError.description, "Base error, internal server error, request failed")
    }
    
    func testGetErrorTypeForStatusCode() {
        XCTAssertEqual(ResponseError.getErrorType(for: 400), ResponseError.invalidRequest)
        XCTAssertEqual(ResponseError.getErrorType(for: 401), ResponseError.unauthorized)
        XCTAssertEqual(ResponseError.getErrorType(for: 403), ResponseError.forbidden)
        XCTAssertEqual(ResponseError.getErrorType(for: 404), ResponseError.resourceNotFound)
        XCTAssertEqual(ResponseError.getErrorType(for: 409), ResponseError.resourceAlreadyExists)
        XCTAssertEqual(ResponseError.getErrorType(for: 500), ResponseError.internalServerError)
        
        XCTAssertNil(ResponseError.getErrorType(for: 200)) // Check for a non-existent status code
    }
}

