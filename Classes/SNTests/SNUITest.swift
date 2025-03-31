//
//  SNUITest.swift
//
//  Created by MorganChen on 2025/3/31.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTest

import XCTest

public class SNUITest: XCTestCase {
    //the page that want to test
    private var viewController: UIViewController?
    
    // Factory method to create instances and configure viewController
    public class func create(viewController: UIViewController) -> SNUITest {
        let instance = SNUITest()
        instance.config(viewController: viewController)
        return instance
    }
    
    /// config method
    /// - Parameter viewController: the page that contains the tableview
    private func config(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    //make sure the view is loaded
    public override func setUpWithError() throws {
        XCTAssertNotNil(viewController, "Please config viewController first")
        viewController?.loadViewIfNeeded()
    }
    
    /// click cell and detect whether if it has jump to the next page
    /// - Parameter indexPath: the index of the click that want to click
    /// - Parameter nextPageClass: the next page viewcontroller type
    public func clickCellAtIndex(indexPath: IndexPath, nextPageClass: AnyClass? = nil, newViewClass: AnyClass? = nil) -> Bool {
        let tableView: UITableView = SNUITestsTool.queryTableViewFromVC(viewController: viewController)
        let result: Bool = SNUITestsTool.tableViewClickIndexPath(tableView: tableView, indexPath: indexPath)
        if !result {
            XCTAssertTrue(result)
            return result
        }

        //verify the behavior after clicking on the third cell, for example:
        // 1.  Did it jump to the correct page
        // 2.  Is there any specific data being transmitted correctly

        if nextPageClass != nil {
            // Check if a new ViewController has been pushed
            let hasPush: Bool = SNUITestsTool.hasPushPage(viewController: viewController, nextPageClass: nextPageClass!)
            if !hasPush {
                XCTAssertTrue(hasPush)
                return hasPush
            }
        }
        if newViewClass != nil {
            // Check if a new ViewController has been pushed
            let isInView: Bool = SNUITestsTool.detectViewIsInViewControllerHierarchy(viewController: viewController, viewClass: newViewClass!)
            if !isInView {
                XCTAssertTrue(isInView)
                return isInView
            }
        }
        XCTAssertTrue(true)
        return true
    }
    
    public func clickBtnAtTag(tag: Int, nextPageClass: AnyClass? = nil, newViewClass: AnyClass? = nil) -> Bool {
        let result: Bool = SNUITestsTool.clickBtnAtTag(viewController: viewController, tag: tag)
        if !result {
            XCTAssertTrue(result)
            return result
        }
        //verify the behavior after clicking on the third cell, for example:
        // 1.  Did it jump to the correct page
        // 2.  Is there any specific data being transmitted correctly

        if nextPageClass != nil {
            // Check if a new ViewController has been pushed
            let hasPush: Bool = SNUITestsTool.hasPushPage(viewController: viewController, nextPageClass: nextPageClass!)
            if !hasPush {
                XCTAssertTrue(hasPush)
                return hasPush
            }
        }
        if newViewClass != nil {
            // Check if a new ViewController has been pushed
            let isInView: Bool = SNUITestsTool.detectViewIsInViewControllerHierarchy(viewController: viewController, viewClass: newViewClass!)
            if !isInView {
                XCTAssertTrue(isInView)
                return isInView
            }
        }
        XCTAssertTrue(true)
        return true
    }
    
    public func tapTabBarItem(index: Int) {
        guard let tabBarController = viewController as? UITabBarController else {
            XCTFail("viewController is not UITabBarController")
            return
        }
        let items = tabBarController.tabBar.items
        XCTAssertTrue(index < items?.count ?? 0, "Tab index out of range")
        tabBarController.selectedIndex = index
        XCTAssertEqual(tabBarController.selectedIndex, index, "TabBar did not switch correctly")
    }
    
    /// polling Label Text is equal expectText or not within timeout
    /// - Parameters:
    ///   - tag: tag of label
    ///   - expectText: expect Text
    ///   - timeOut: timeout second
    ///   - timeInterval: polling time Interval
    public func pollingLabelText(tag: Int, expectText: String, timeOut: UInt) -> Bool {
        return SNUITestsTool.pollingLabelText(testCase: self, viewController: viewController, tag: tag, expectText: expectText, timeOut: timeOut)
        
    }
    
}
