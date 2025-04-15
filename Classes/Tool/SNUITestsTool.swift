//
//  SNUITestsTool.swift
//
//  Created by MorganChen on 2025/3/31.
//  Copyright © 2025 MorganChen. All rights reserved.
//https://github.com/Json031/SNUnitTest

import XCTest

public class SNUITestsTool {
    
    // MARK: - query sub view
    /// Select tableView from viewController
    /// - Parameter viewController: viewController
    /// - Returns: UITableView
    public class func queryTableViewFromVC(viewController: UIViewController?) -> UITableView {
        var tableView: UITableView?
        for subView: UIView in viewController?.view.subviews ?? [] {
            if subView.isKind(of: UITableView.self) {
                tableView = subView as? UITableView
                break
            }
        }
        // Ensure that tableView has at least indexPath.section sections
        XCTAssertNotNil(tableView, "viewController's tableView is nil")
        return tableView!
    }
    
    /// Select btn from viewController where match the tag param
    /// - Parameter viewController: viewController
    /// - Parameter tag: tag
    /// - Returns: UIButton
    public class func queryBtnFromTag(viewController: UIViewController?, tag: Int) -> UIButton? {
        return SNUITestsTool.queryViewFromTag(viewController: viewController, tag: tag) as? UIButton
    }
    
    /// Select lab from viewController where match the tag param
    /// - Parameter viewController: viewController
    /// - Parameter tag: tag
    /// - Returns: UILabel
    public class func queryLabFromTag(viewController: UIViewController?, tag: Int) -> UILabel? {
        return SNUITestsTool.queryViewFromTag(viewController: viewController, tag: tag) as? UILabel
    }
    
    /// 递归查找 UIViewController 视图层级中任何层级的 UIView，根据 tag 进行匹配
    /// Recursive search for UIViews at any level in the UIViewController view hierarchy, matching based on tags
    /// - Parameters:
    ///   - viewController: UIViewController
    ///   - tag: tag
    /// - Returns: UIView
    public class func queryViewFromTag(viewController: UIViewController?, tag: Int) -> UIView? {
        guard let rootView = viewController?.view else { return nil }
        return findViewWithTag(rootView, tag: tag)
    }

    // 递归遍历视图层级查找特定 tag 的 UIView
    /// Recursive traversal of view hierarchy to find UIView for a specific tag
    /// - Parameter viewController: viewController
    /// - Parameter tag: tag
    /// - Returns: UIView
    private class func findViewWithTag(_ view: UIView, tag: Int) -> UIView? {
        if view.tag == tag {
            return view
        }
        for subview in view.subviews {
            if let foundView = findViewWithTag(subview, tag: tag) {
                return foundView
            }
        }
        return nil
    }

    
    // MARK: - click event
    /// Click tableView at indexPath
    /// - Parameter tableView: tableView
    /// - Parameter indexPath: indexPath
    /// - Returns: result
    public class func tableViewClickIndexPath(tableView: UITableView, indexPath: IndexPath) -> Bool {
        let numberOfSections = tableView.numberOfSections
        XCTAssertTrue(numberOfSections >= indexPath.section, "TableView requires at least \(indexPath.section) sections of data")
        if numberOfSections < indexPath.section {
            XCTAssertTrue(numberOfSections >= indexPath.section)
            return numberOfSections >= indexPath.section
        }
        // Ensure that tableView has at least indexPath.row cells
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        XCTAssertTrue(numberOfRows >= indexPath.row, "TableView requires at least \(indexPath.row) rows of data")
        if numberOfRows < indexPath.row {
            XCTAssertTrue(numberOfRows >= indexPath.row)
            return numberOfRows >= indexPath.row
        }

        // Simulate the cell of the click location index Path
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        return true
        //verify the behavior after clicking on the third cell, for example:
        // 1.  Did it jump to the correct page
        // 2.  Is there any specific data being transmitted correctly

    }
    
    /// check whether if Label Text is equal expectedText
    /// - Parameters:
    ///   - tag: the tag of label
    ///   - expectedText: expectedText
    public class func checkLabelText(viewController: UIViewController?, tag: Int, expectedText: String) {
        let label = viewController?.view.viewWithTag(tag) as? UILabel
        XCTAssertNotNil(label, "UILabel with tag \(tag) not found")
        XCTAssertEqual(label?.text, expectedText, "UILabel text mismatch")
    }
    
    /// Click btn with tag
    /// - Parameter viewController: viewController
    /// - Parameter tag: tag
    /// - Returns: result
    public class func clickBtnAtTag(viewController: UIViewController?, tag: Int) -> Bool {
        let btn: UIButton? = SNUITestsTool.queryBtnFromTag(viewController: viewController, tag: tag)
        // Ensure that tableView has at least indexPath.section sections
        XCTAssertNotNil(btn, "viewController's btn is nil")
        btn?.sendActions(for: .touchUpInside)
        return btn != nil
    }
    
    // MARK: - View detect
    /// Check if a specific UIView exists in the view hierarchy of the ViewController
    /// - Parameter viewController: viewController
    /// - Parameter viewClass: detectView
    /// - Returns: result
    public class func detectViewIsInViewControllerHierarchy(viewController: UIViewController?, viewClass: AnyClass) -> Bool {
        // Assuming we want to check if a UIButton appears in the view假设我们想检查UIButton是否出现在视图中
        let view = viewController?.view.subviews.first(where: { $0.isKind(of: viewClass.self)  })
        
        // Does the assertion button exist断言按钮是否存在
        XCTAssertNotNil(view, "The view should be present in the view hierarchy")
        return view != nil
    }
    
    /// Check if Push is successful
    /// - Parameter nextPageClass: the next page viewcontroller type
    /// - Parameter nextPageClass: nextPage class
    /// - Returns: result
    public class func hasPushPage(viewController: UIViewController?, nextPageClass: AnyClass) -> Bool {
        // Check if a new ViewController has been pushed
        if let navigationController = viewController?.navigationController {
            let topViewController = navigationController.topViewController
            XCTAssertNotEqual(topViewController, viewController, "After clicking, it should redirect to a new page")
            if topViewController == viewController {
                return false
            }
            // ✅ Claiming whether topViewController is of type nextPageClass
            XCTAssertTrue(topViewController?.isKind(of: nextPageClass) ?? false, "The redirected View Controller should be \(String(describing: nextPageClass)), but in reality it is \(String(describing: topViewController))")
            return topViewController?.isKind(of: nextPageClass) ?? false
        }
        return false
    }
    
    /// Check if pop is successful
    /// - Parameter viewController: pop target
    /// - Parameter initialVCCount: Number of pages before pop execution
    public class func detectPop(viewController: UIViewController?, initialVCCount: Int) {
        guard let navigationController = viewController?.navigationController else {
            XCTFail("viewController is not in UINavigationController")
            return
        }
        XCTAssertEqual(navigationController.viewControllers.count, initialVCCount - 1, "Navigation pop failed")
    }
    
    /// polling Label Text is equal expectText or not within timeout
    /// - Parameters:
    ///   - viewController: viewController
    ///   - tag: tag of label
    ///   - expectText: expect Text
    ///   - timeOut: timeout second
    ///   - timeInterval: polling time Interval
    public class func pollingLabelText(testCase: XCTestCase, viewController: UIViewController?, tag: Int, expectText: String, timeOut: UInt, timeInterval: CGFloat = 0.5) -> Bool {
        
        // get label
        let label = SNUITestsTool.queryLabFromTag(viewController: viewController, tag: tag)
        
        // Is UILabel nil  UILabel是否为nil
        XCTAssertNotNil(label, "The UILabel should be present in the view hierarchy")
        
        // timer to detect label text
        let startTime = Date()
        
        while true {
            if UInt(Date().timeIntervalSince(startTime)) < timeOut {
                // is text equal expectText
                if label?.text == expectText {
                    // If expectText is matched, meet the expectation and exit the loop
                    XCTAssertTrue(true)
                    return true
                }
                // If there is no match, continue to wait for a period of time before checking again
                Thread.sleep(forTimeInterval: timeInterval > 0 ? timeInterval : 0.5)
            } else {
                let isEqual: Bool = label?.text == expectText
                XCTAssertTrue(isEqual, "Label text should become \(expectText) within \(timeOut) seconds")
                return isEqual
            }
        }
    }

}
