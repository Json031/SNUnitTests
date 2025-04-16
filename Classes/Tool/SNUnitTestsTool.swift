//
//  SNUnitTestsTool.swift
//
//  Created by MorganChen on 2025/4/9.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTests
//

import XCTest

public class SNUnitTestsTool {
    
    /// 断言结果是否等于预期
    /// Is the assertion result equal to the expected outcome
    /// - Parameters:
    ///   - result: 执行方法获得的结果
    ///   - expected: 预期结果
    public class func xctAssertEqual<R: Equatable>(result: R, expected: R,
                                                   failMessage: String? = nil) {
        if let message = failMessage {
            XCTAssertEqual(result, expected, message)
        } else {
            XCTAssertEqual(result, expected, "返回值与预期不一致The return value is inconsistent with the expected value")
        }
    }
    
    /// Create XCTestExpectation
    /// - Parameters:
    ///   - description: description for test expectation
    ///   - iterations: iterations count value
    /// - Returns: XCTestExpectation
    public class func createXCTestExpectation(description: String, iterations: Int) -> XCTestExpectation {
        let expectation: XCTestExpectation = XCTestExpectation(description: description)
        expectation.expectedFulfillmentCount = iterations
        return expectation
    }
}
