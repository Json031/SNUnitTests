//
//  SNUnitTests.swift
//
//  Created by MorganChen on 2025/4/9.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTest
//

import XCTest

public class SNUnitTests: XCTestCase {
    
    /// 获取classType对象方法method传参param得到的结果
    /// Get the result obtained by passing the parameter 'param' to the method of the classType object
    /// - Parameters:
    ///   - classType: classType对象
    ///   - method: 方法method
    ///   - param: 传参param
    public func getMethodResult<T: NSObject, P, R: Equatable>(
        classType: T.Type,
        method: (T) -> (P?) -> R,
        param: P? = nil
    ) -> R {
        // 实例化classType对象
        //Instantiate classType object
        let instance: T = classType.init()
        
        // 调用对象instance的方法method
        //Call method of object instance
        let result: R = method(instance)(param)
        
        return result
    }
    
    /// 获取类方法method传参param得到的结果
    /// Get the result obtained by passing the parameter 'param' to the test class method
    /// - Parameters:
    ///   - method: 类方法method Class Method
    ///   - param: 传参param
    public func getClassMethodResult<P, R: Equatable>(
        method: (P?) -> R,
        param: P? = nil
    ) -> R {
        //调用类方法
        //call class method
        let result: R = method(param ?? nil)
        return result
    }
    
    
    /// 测试classType对象方法method传参param得到的结果是否与预期expected一致
    /// Test whether the result obtained by passing the parameter 'param' to the method of the classType object is consistent with the expected result
    /// - Parameters:
    ///   - classType: classType对象
    ///   - method: 方法method
    ///   - param: 传参param
    ///   - expected: 预期expected
    public func testMethodCall<T: NSObject, P, R: Equatable>(
        classType: T.Type,
        method: (T) -> (P?) -> R,
        param: P? = nil,
        expected: R,
        failMessage: String? = nil
    ) {
        // 获取对象方法method结果
        // get result of method function
        let result: R = self.getMethodResult(classType: classType, method: method, param: param)
        
        /// 断言结果是否等于预期
        /// Is the assertion result equal to the expected outcome
        SNUnitTestsTool.xctAssertEqual(result: result, expected: expected, failMessage: failMessage)
    }
    
    /// 测试类方法method传参param得到的结果是否与预期expected一致
    /// Is the result obtained by passing the parameter 'param' to the test class method consistent with the expected result
    /// - Parameters:
    ///   - method: 类方法method Class Method
    ///   - param: 传参param
    ///   - expected: 预期expected
    public func testClassMethodCall<P, R: Equatable>(
        method: (P?) -> R,
        param: P? = nil,
        expected: R,
        failMessage: String? = nil
    ) {
        //获取类方法结果
        //get result of class method
        let result: R = self.getClassMethodResult(method: method, param: param)
        
        /// 断言结果是否等于预期
        /// Is the assertion result equal to the expected outcome
        SNUnitTestsTool.xctAssertEqual(result: result, expected: expected, failMessage: failMessage)
    }
    
    /// 高并发单元测试
    /// - Parameters:
    ///   - iterations: 高并发次数
    ///   - timeoutSeconds: 超时秒数
    ///   - classType: 类
    ///   - method: 方法
    ///   - param: 参数
    ///   - expected: 期望值
    public func highConcurrencyUnitTestingForClassMethod<T: NSObject, P, R: Equatable>(
        iterations: Int = 1000,
        timeoutSeconds: Double = 60.0,
        classType: T.Type,
        method: (T) -> (P?) -> R,
        param: P? = nil,
        expected: R,
        verbose: Bool = false
    ) {
        //兼容异步环境Compatible with asynchronous environments
        let expectation: XCTestExpectation = SNUnitTestsTool.createXCTestExpectation(description: "High concurrency unit testing for class method checks", iterations: iterations)

        let lock: NSLock = NSLock()
        var failedIndices: [Int] = []

        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let result = self.getMethodResult(classType: classType, method: method, param: param)
            if result != expected {
                lock.lock()
                failedIndices.append(index)
                lock.unlock()
                if verbose {
                    print("❌Doesn't match the expected value at \(index)th unit test, expected: \(expected), but got: \(result)")
                }
            } else {
                if verbose {
                    print("✅Match the expected value at \(index)th unit test")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeoutSeconds)

        XCTAssertTrue(failedIndices.isEmpty, "Failures occurred at indices: \(failedIndices)")
    }
}
