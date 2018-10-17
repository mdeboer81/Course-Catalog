//
//  Course CatalogUITestsCS3260.swift
//  Course CatalogUITests
//
//  Created by Ted Cowan on 9/26/18.
//  Copyright © 2018 Ted Cowan. All rights reserved.
//

import XCTest

class Course_CatalogUITestsCS3260: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLabelsButtonsAndSwitchArePresent() {
        let headingLabel = app.staticTexts["Course Catalog"]
        XCTAssert(headingLabel.exists)
        let switchLabel = app.staticTexts["Show Only Selected Courses"]
        XCTAssert(switchLabel.exists)
        let mySwitch = app.switches["showOnlySelectedCoursesSwitch"]
        XCTAssert(mySwitch.exists)
    }
    
    func testTableViewIsLoaded() {
        let tableView = app.tables.element(boundBy: 0)
        XCTAssertTrue(tableView.exists, "The Course Catalog table view exists")
        let rowCount = tableView.cells.count
        XCTAssert(rowCount == 57, "Table should have 57 rows, but found \(rowCount)")
        let cells = tableView.children(matching: .cell)
        print(cells.count)
        
        for i in [0, 10, 20, 30, 40, 50, 56] {
            let texts = cells.element(boundBy: i).staticTexts
            let title = texts.element(boundBy: 0).label
            let subTitle = texts.element(boundBy: 1).label
            print("\(i): \(title) \(subTitle)")
            switch i {
            case 0: XCTAssert(title == "CS 1010" && subTitle == "Introduction to Interactive Entertainment")
            case 10: XCTAssert(title == "CS 2420" && subTitle == "Introduction to Data Structures and Algorithms")
            case 20: XCTAssert(title == "CS 3040" && subTitle == "Windows/Unix/Linux Infrastructure and Administration")
            case 30: XCTAssert(title == "CS 3610" && subTitle == "Introduction to Game Industry")
            case 40: XCTAssert(title == "CS 4280" && subTitle == "Computer Graphics")
            case 50: XCTAssert(title == "CS 4800" && subTitle == "Individual Projects and Research")
            case 56: XCTAssert(title == "MGMT 2400" && subTitle == "Project Management")
            default: print("\(i): \(title) \(subTitle)")
            }
        }
        var lastCourse = ""
        for i in 0...56 {
            let texts = cells.element(boundBy: i).staticTexts
            let title = texts.element(boundBy: 0).label
            XCTAssert(title >= lastCourse, "Courses are not sorted in ascending order")
            lastCourse = title
        }
    }
    
    func testOneCourseIsSelected() {
        let tableView = app.tables.element(boundBy: 0)
        XCTAssertTrue(tableView.exists, "The Course Catalog table view exists")
        let rowCount = tableView.cells.count
        XCTAssert(rowCount == 57, "Table should have 57 rows, but found \(rowCount)")
        let cells = tableView.children(matching: .cell)
        cells.element(boundBy: 20).tap()
        let buttons = cells.element(boundBy: 20).buttons
        XCTAssert(buttons.count > 0, "CS 3040 entry in table is not checked")
    }
    
    func testMultipleCoursesAreSelected() {
        let tableView = app.tables.element(boundBy: 0)
        let cells = tableView.children(matching: .cell)
        cells.element(boundBy: 4).tap()                     // tap cs1400
        cells.element(boundBy: 10).tap()                    // tap cs2420
        cells.element(boundBy: 25).tap()                    // tap cs3260
        
        var texts = cells.element(boundBy: 4).staticTexts   // CS 1400
        let cs1400 = texts.element(boundBy: 0).label
        var buttons = cells.element(boundBy: 4).buttons
        XCTAssert(cs1400 == "CS 1400" && buttons.count > 0, "CS 1400 entry is not checked")
        
        texts = cells.element(boundBy: 10).staticTexts      // CS 2420
        let cs2420 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 10).buttons
        XCTAssert(cs2420 == "CS 2420" && buttons.count > 0, "CS 2420 entry is not checked")

        texts = cells.element(boundBy: 25).staticTexts      // CS 3260
        let cs3260 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 25).buttons
        XCTAssert(cs3260 == "CS 3260" && buttons.count > 0, "CS 3260 entry is not checked")
    }
    
    func testSwitchDisplaysOnlySelectedCourses() {
        let tableView = app.tables.element(boundBy: 0)
        var cells = tableView.children(matching: .cell)
        cells.element(boundBy: 21).tap()                    // tap cs3100
        cells.element(boundBy: 3).tap()                     // tap cs1030
        cells.element(boundBy: 35).tap()                    // tap cs3805
        app.switches["showOnlySelectedCoursesSwitch"].tap()
        
        // at this point, there should only be 3 rows in the table, sorted and checked
        cells = tableView.children(matching: .cell)
        let rowCount = tableView.cells.count
        XCTAssert(rowCount == 3, "Table should have 3 rows, but found \(rowCount)")

        var texts = cells.element(boundBy: 0).staticTexts   // CS 1030
        let cs1030 = texts.element(boundBy: 0).label
        var buttons = cells.element(boundBy: 0).buttons
        XCTAssert(cs1030 == "CS 1030", "CS 1030 entry is missing")
        XCTAssert(buttons.count > 0, "CS 1030 entry is not checked")

        texts = cells.element(boundBy: 1).staticTexts       // CS 3100
        let cs3100 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 1).buttons
        XCTAssert(cs3100 == "CS 3100", "CS 3100 entry is missing")
        XCTAssert(buttons.count > 0, "CS 3100 entry is not checked")

        texts = cells.element(boundBy: 2).staticTexts       // CS 3805
        let cs3805 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 2).buttons
        XCTAssert(cs3805 == "CS 3805", "CS 3805 entry is missing")
        XCTAssert(buttons.count > 0, "CS 3805 entry is not checked")

    }
    
    func testSwitchToggleRedisplaysSelectedCourses() {
        let tableView = app.tables.element(boundBy: 0)
        let cells = tableView.children(matching: .cell)
        cells.element(boundBy: 4).tap()                     // tap cs1400
        cells.element(boundBy: 10).tap()                    // tap cs2420
        cells.element(boundBy: 25).tap()                    // tap cs3260
        
        app.switches["showOnlySelectedCoursesSwitch"].tap()
        app.switches["showOnlySelectedCoursesSwitch"].tap()

        var texts = cells.element(boundBy: 4).staticTexts   // CS 1400
        let cs1400 = texts.element(boundBy: 0).label
        var buttons = cells.element(boundBy: 4).buttons
        XCTAssert(cs1400 == "CS 1400" && buttons.count > 0, "CS 1400 entry is not checked")
        
        texts = cells.element(boundBy: 10).staticTexts      // CS 2420
        let cs2420 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 10).buttons
        XCTAssert(cs2420 == "CS 2420" && buttons.count > 0, "CS 2420 entry is not checked")
        
        texts = cells.element(boundBy: 25).staticTexts      // CS 3260
        let cs3260 = texts.element(boundBy: 0).label
        buttons = cells.element(boundBy: 25).buttons
        XCTAssert(cs3260 == "CS 3260" && buttons.count > 0, "CS 3260 entry is not checked")
    }
    
}

