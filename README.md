<h1 align="center"><a href="https://github.com/Json031/SNUnitTestsOC"><img src="https://img.shields.io/badge/Objective--C-007AFF?logo=apple&logoColor=white" title="Objective-C" float=left></a><strong><a href="https://github.com/Json031/SNUnitTestsOC">Click here to go to the Objective-C version</a></strong></h1>

# SNUnitTests
[![CocoaPods](https://img.shields.io/cocoapods/v/SNUnitTests.svg)](https://cocoapods.org/pods/SNUnitTests)
![Swift 5](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/Json031/SNUnitTests/blob/main/LICENSE)
<br>
SNUnitTests 是一个基于XCTest框架开发的Swift开源项目，集成了 UI 自动化测试、高并发 以及 覆盖 API与类方法等范围的单元测试，方便开发者对应用程序的 UI 、 API、类方法高并发等模块 进行全面的自动化单元测试。
<br>SNUnitTests is a Swift open source project developed based on the XCTest framework, which integrates UI automation testing, high concurrency, and unit testing covering APIs and class methods, making it convenient for developers to understand the UI API、 Conduct comprehensive automated unit testing on high concurrency modules such as class methods.

* 最新版本 Latest Version: 

# Installation 安装:

* CocoaPods
The [SNUnitTests SDK for iOS](https://github.com/Json031/SNUnitTests) is available through [CocoaPods](http://cocoapods.org). If CocoaPods is not installed, install it using the following command. Note that Ruby will also be installed, as it is a dependency of Cocoapods.

```bash
    brew install cocoapods
    pod setup
```
```bash
   $iOSVersion = '11.0'
   
   platform :ios, $iOSVersion
   use_frameworks!
   
   target 'YourProjectName' do

       target 'YourProjectNameTests' do
          inherit! :search_paths

          pod 'SNUnitTests' # Full version with all features
       end
   end
```

* 手动安装 manual install
将Classes文件夹拽入项目中，OC项目还需要桥接
<br>Drag the Classes folder into the project, OC project still needs bridging

# Effect demonstration 效果演示
<p align="center">
  <img src="https://github.com/user-attachments/assets/c93afea4-bbd2-4e64-8706-4c8c67795133" width="300" style="border: 2px solid blue;" />
  <img src="https://github.com/user-attachments/assets/01569c52-77cb-4fe5-b207-9fbc115b5d42" width="300" style="border: 2px solid blue;" />  
</p>

# 功能特性function characteristics
### UI 单元测试UI unit testing
* 查找视图元素：通过标签（tag）递归查找 UIViewController 视图层级中任何层级的 UIView，支持查找 UIButton、UILabel 和 UITableView。
* 模拟点击事件：支持模拟点击表格视图（UITableView）的单元格和按钮（UIButton），并验证点击后是否跳转到正确的页面。
* 检查视图存在性：检查特定的 UIView 是否存在于 ViewController 的视图层级中。
* 检查标签文本：检查 UILabel 的文本是否与预期文本相等。
* 轮询标签文本：在指定的超时时间内轮询 UILabel 的文本是否等于预期文本。
* 切换标签栏：支持切换 UITabBarController 的标签项。
* Search for view elements: recursively search for UIViews at any level in the UIViewController view hierarchy through tags, supporting the search for UIButton, UILabel, and UITableView.
* Simulate click events: Support simulating clicking on cells and buttons (UIButton) in the UITableView, and verify whether clicking leads to the correct page.
* Check view existence: Check if a specific UIView exists in the view hierarchy of the ViewController.
* Check label text: Check if the text on the UILabel matches the expected text.
* Polling label text: Polling whether the text of the UILabel is equal to the expected text within the specified timeout period.
* Switching label bar: Supports switching label items for UITabBarController.

### API 及 对象方法与类方法 单元测试API & Object method and class method Unit Testing
* 对象方法测试：测试对象方法执行结果与预期结果是否匹配
* 类方法测试：测试类方法执行结果与预期结果是否匹配
* 响应状态码测试：测试 API 响应的状态码是否符合预期。
* 响应时间测试：测试 API 的响应时间是否在指定的超时时间内。
* JSON 有效性测试：测试 API 响应是否为有效的 JSON 数据。
* 必需字段检查：检查 API 响应的 JSON 数据是否包含必需的字段。
* 404 响应测试：测试无效端点的 API 是否返回 404 状态码。
* POST 请求测试：测试 API 的 POST 请求是否成功。
* Object method testing: Test whether the execution result of the object method matches the expected result
* Class method testing: testing whether the execution result of the class method matches the expected result
* Response Status Code Test: Test whether the status code of the API response meets expectations.
* Response time test: Test whether the API's response time is within the specified timeout period.
* JSON validity test: Test whether the API response is valid JSON data.
* Required field check: Check if the JSON data in the API response contains the required fields.
* 404 response test: Test whether the API of an invalid endpoint returns a 404 status code.
* POST Request Test: Test whether the API's POST request is successful.

# 代码示例code example
### UI 自动化测试示例UI Automated Testing Example
   ```bash
      import XCTest
      import SNUnitTests
      
      class MyUITests: XCTestCase {
          func testUIComponents() {
              let viewController = MyViewController()
              let uiTest = SNUITest.create(viewController: viewController)
              
              // 点击按钮并验证是否跳转到正确页面Click the button and verify if it redirects to the correct page
              let result = uiTest.clickBtnAtTag(tag: 1, nextPageClass: NextViewController.self)
              XCTAssertTrue(result)
              
              // 点击表格视图单元格并验证是否跳转到正确页面Click on the table view cell and verify if you are redirected to the correct page
              let indexPath = IndexPath(row: 0, section: 0)
              let cellResult = uiTest.clickCellAtIndex(indexPath: indexPath, nextPageClass: NextViewController.self)
              XCTAssertTrue(cellResult)
              
              // 切换标签栏项Switch tab bar items
              uiTest.tapTabBarItem(index: 1)
              
              // 轮询标签文本Polling label text
              let pollingResult = uiTest.pollingLabelText(tag: 2, expectText: "Expected Text", timeOut: 5)
              XCTAssertTrue(pollingResult)
          }
      }
   ```

### API 单元测试示例API Unit Test Example
   ```bash
      import XCTest
      import SNUnitTests
      
      class MyAPITests: XCTestCase {
          func testAPIResponses() {
              let apiTests = SNAPITests()
              let apiAddress = "https://example.com/api"
              
              // 测试 API 响应状态码Test API response status code
              let statusCodeResult = apiTests.testAPIResponseCode(apiAddress: apiAddress, rspCode: 200, timeOut: 5)
              XCTAssertTrue(statusCodeResult)
              
              // 测试 API 响应时间Test API response time
              let responseTimeResult = apiTests.testAPIResponseTime(apiAddress: apiAddress, milliSecondTimeOut: 2000)
              XCTAssertTrue(responseTimeResult)
              
              // 测试 API 响应是否为有效 JSONTest whether the API response is valid JSON
              apiTests.testAPIResponseIsValidJSON(apiAddress: apiAddress)
              
              // 测试 API 响应是否包含必需字段Test whether the API response contains required fields
              apiTests.testAPIResponseContainsRequiredFields(testCase: self, apiAddress: apiAddress)
              
              // 测试无效端点的 API 是否返回 404Test whether the API for invalid endpoints returns 404
              apiTests.testAPINotFoundResponse(testCase: self, apiAddress: "https://example.com/invalid-api")
              
              // 测试 API 的 POST 请求POST request for testing API
              apiTests.testAPIPostRequest(testCase: self, apiAddress: apiAddress)
          }
      }
   ```

### 对象方法与类方法功能性及行为驱动单元测试示例 <br> Example of functional and behavior driven unit testing for object methods and class methods
```
class UnityTool: NSObject {
    class func isEmptyStr(str: String?) -> Bool {
        return str == "" || str == nil
    }
    func isValidStr(_ input: String?) -> Bool {
        return input != "" && input != nil
    }
}
```
```
import SNUnitTests
import XCTest

@testable import XXXProject

class MyCodesTests: XXXProjectTests {
    
    var snUnitTests: SNUnitTests!
    
    override func setUpWithError() throws {
        if snUnitTests == nil {
            snUnitTests = SNUnitTests()
        }
    }
    
    func testCodes() throws {
        snUnitTests.testMethodCall(classType: UnityTool.self, method: UnityTool.isValidStr(_:), param: "xxx", expected: true)
        
        snUnitTests.testClassMethodCall(method: UnityTool.isEmptyStr(str:), param: "xxx", expected: false)
        
        let result = snUnitTests.getMethodResult(classType: UnityTool.self, method: UnityTool.isValidStr(_:), param: "xxx")
        print("UnityTool.self isValidStr result:\(result)")
        
        let classMethodResult = snUnitTests.getClassMethodResult(method: UnityTool.isEmptyStr(str:), param: "xxx")
        print("UnityTool.isEmptyStr(str:) result:\(classMethodResult)")
        
    }

}
```
对象方法与类方法单元测试结果 <br>Object Method and Class Method Unit Test Results:
![image](https://github.com/user-attachments/assets/c144fa9f-0b01-4b2e-9cf8-7d32a73888bc)

![image](https://github.com/user-attachments/assets/14e7618f-3222-440e-813a-8d8b78dcd3c6)


###  类方法的高并发单元测试 <br>High concurrency unit testing for class methods.
```
//示例：对类UnityTool的类方法isValidStr进行高并发测试1000次，超时时间1000秒
//Example: Conduct high concurrency testing on the class method isValidStr of UnityTool 1000 times, with a timeout of 1000 seconds
snUnitTests.highConcurrencyUnitTestingForClassMethod(iterations: 1000,
                                                     timeoutSeconds: 1000,
                                                     classType: UnityTool.self,
                                                     method: UnityTool.isValidStr(_:),
                                                     param: "sdnjanf",
                                                     expected: true)
```
![高并发单元测试](https://github.com/user-attachments/assets/73ccec3e-bb8e-45d2-956f-c6662029ab59)


# 问题或改进建议 <br> issues or improvement suggestions
如果你发现任何问题或有改进建议，请在 GitHub 上提交 [issue](https://github.com/Json031/SNUnitTests/issues) 或 [pull request](https://github.com/Json031/SNUnitTests/pulls)。
<br>If you find any issues or have improvement suggestions, please submit [issue](https://github.com/Json031/SNUnitTests/issues) Or [pull request][pull request](https://github.com/Json031/SNUnitTests/pulls) on GitHub.

# MIT 许可证 <br> MIT license
本项目采用 MIT 许可证，详情请参阅 [MIT License](https://github.com/Json031/SNUnitTests/blob/main/LICENSE) 文件。
<br>This project adopts the MIT license, please refer to the [MIT License](https://github.com/Json031/SNUnitTests/blob/main/LICENSE) document for details.
