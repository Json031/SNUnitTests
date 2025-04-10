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
        let instance = classType.init()
        
        // 调用对象instance的方法method
        //Call method of object instance
        let result = method(instance)(param)
        
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
        let result = method(param ?? nil)
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
        expected: R
    ) {
        // 获取对象方法method结果
        // get result of method function
        let result = self.getMethodResult(classType: classType, method: method, param: param)
        
        /// 断言结果是否等于预期
        /// Is the assertion result equal to the expected outcome
        SNUnitTestsTool.xctAssertEqual(result: result, expected: expected)
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
        expected: R
    ) {
        //获取类方法结果
        //get result of class method
        let result = self.getClassMethodResult(method: method, param: param)
        
        /// 断言结果是否等于预期
        /// Is the assertion result equal to the expected outcome
        SNUnitTestsTool.xctAssertEqual(result: result, expected: expected)
    }
}
