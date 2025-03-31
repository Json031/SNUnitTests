//
//  SNAPITestsTool.swift
//
//  Created by MorganChen on 2025/3/31.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTest

import XCTest

public class SNAPITestsTool: XCTestCase {
    
    /// test API Response Code
    /// - Parameters:
    ///   - apiAddress: apiAddress
    ///   - rspCode: rspCode
    public class func testAPIResponseCode(testCase: XCTestCase, apiAddress: String, rspCode: Int, timeOut: UInt) -> Bool {
        let expectation = testCase.expectation(description: "API should return code \(rspCode)")
        var success = false  // 记录测试结果
        
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return false
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { expectation.fulfill() } // Ensure that everything will ultimately be fulfilled
            
            if let error = error {
                XCTFail("Request failed with error: \(error.localizedDescription)")
                success = false
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("Invalid response")
                success = false
                return
            }
            success = httpResponse.statusCode == 200
            XCTAssertEqual(httpResponse.statusCode, 200, "Expected status code \(rspCode), but got \(httpResponse.statusCode)")
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: TimeInterval(timeOut)) //Set timeout period to avoid test suspension caused by no response 设置超时时间，避免无响应导致测试挂起
        return success
    }
    
    /// test API Response Time
    /// - Parameters:
    ///   - apiAddress: apiAddress
    ///   - milliSecondTimeOut: timeOut
    public class func testAPIResponseTime(testCase: XCTestCase, apiAddress: String, milliSecondTimeOut: UInt = 2000) -> Bool {
        let expectation = testCase.expectation(description: "API response within 1 second")
        var success = false  // 记录测试结果
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return false
        }
        let startTime = Date()
        
        let task = URLSession.shared.dataTask(with: url) { _, _, _ in
            let milliSecondDuration = UInt(Date().timeIntervalSince(startTime) * 1000)
            print("API response cost time \(milliSecondDuration) millisecond")
            success = milliSecondDuration < milliSecondTimeOut
            XCTAssert(success, "API response took too long: \(milliSecondDuration) millisecond")
            expectation.fulfill()
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: 60)
        return success
    }
    
    public class func testAPIResponseIsValidJSON(testCase: XCTestCase, apiAddress: String) {
        let expectation = testCase.expectation(description: "API should return valid JSON")
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { expectation.fulfill() }
            
            XCTAssertNil(error, "Request failed: \(error?.localizedDescription ?? "Unknown error")")
            
            guard let data = data else {
                XCTFail("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                XCTAssertNotNil(json, "Response is not a valid JSON")
            } catch {
                XCTFail("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: 5)
    }
    
    
    public class func testAPIResponseContainsRequiredFields(testCase: XCTestCase, apiAddress: String) {
        let expectation = testCase.expectation(description: "API response should contain required fields")
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { expectation.fulfill() }
            
            XCTAssertNil(error, "Request failed: \(error?.localizedDescription ?? "Unknown error")")
            guard let data = data else {
                XCTFail("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    XCTAssertNotNil(json["userId"], "Missing 'userId' field")
                    XCTAssertNotNil(json["id"], "Missing 'id' field")
                    XCTAssertNotNil(json["title"], "Missing 'title' field")
                    XCTAssertNotNil(json["body"], "Missing 'body' field")
                } else {
                    XCTFail("Invalid JSON format")
                }
            } catch {
                XCTFail("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: 5)
    }
    
    public class func testAPINotFoundResponse(testCase: XCTestCase, apiAddress: String) {
        let expectation = testCase.expectation(description: "API should return 404 for invalid endpoint")
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { _, response, _ in
            defer { expectation.fulfill() }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("Invalid response")
                return
            }
            XCTAssertEqual(httpResponse.statusCode, 404, "Expected status code 404, but got \(httpResponse.statusCode)")
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: 5)
    }
    
    public class func testAPIPostRequest(testCase: XCTestCase, apiAddress: String) {
        let expectation = testCase.expectation(description: "POST request should succeed")
        guard let url = URL(string: apiAddress) else {
            XCTFail("Invalid URL: \(apiAddress)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = ["title": "foo", "body": "bar", "userId": 1]
        request.httpBody = try? JSONSerialization.data(withJSONObject: postData)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            defer { expectation.fulfill() }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("Invalid response")
                return
            }
            XCTAssertEqual(httpResponse.statusCode, 201, "Expected status code 201, but got \(httpResponse.statusCode)")
        }
        
        task.resume()
        testCase.wait(for: [expectation], timeout: 5)
    }

}
