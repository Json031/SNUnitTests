//
//  SNAPITests.swift
//
//  Created by MorganChen on 2025/3/31.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTest
//

import XCTest

public class SNAPITests: XCTestCase {
    
    /// test API Response Code
    /// - Parameters:
    ///   - apiAddress: apiAddress
    ///   - rspCode: rspCode
    public func testAPIResponseCode(apiAddress: String, rspCode: Int, timeOut: UInt) -> Bool {
        let result: Bool = SNAPITestsTool.testAPIResponseCode(testCase: self, apiAddress: apiAddress, rspCode: rspCode, timeOut: timeOut)
        return result
    }
    
    /// test API Response Code
    /// - Parameters:
    ///   - apiAddress: apiAddress
    ///   - milliSecondTimeOut: milliSecondTimeOut
    public func testAPIResponseTime(apiAddress: String, milliSecondTimeOut: UInt = 2000) -> Bool {
        let result: Bool = SNAPITestsTool.testAPIResponseTime(testCase: self, apiAddress: apiAddress, milliSecondTimeOut: milliSecondTimeOut)
        return result
    }
    
    public func testAPIResponseIsValidJSON(apiAddress: String) {
        SNAPITestsTool.testAPIResponseIsValidJSON(testCase: self, apiAddress: apiAddress)
    }
    
    public func testAPIResponseContainsRequiredFields(testCase: XCTestCase, apiAddress: String) {
        SNAPITestsTool.testAPIResponseContainsRequiredFields(testCase: self, apiAddress: apiAddress)
    }
    public func testAPINotFoundResponse(testCase: XCTestCase, apiAddress: String) {
        SNAPITestsTool.testAPINotFoundResponse(testCase: self, apiAddress: apiAddress)
    }
    
    public func testAPIPostRequest(testCase: XCTestCase, apiAddress: String) {
        SNAPITestsTool.testAPIPostRequest(testCase: self, apiAddress: apiAddress)
    }
}
