//
//  DataModelTests.swift
//  AcrossGeographyTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import XCTest
@testable import AcrossGeography

class DataModelTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
}
    func testModelIsInvalid() {
        let model = FactsDataModel(title: "Test", rows: [DataModelInfoDetails(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")])
        XCTAssertNotNil(model.rows[0].title)
    }
    func testModelIsValid() {
        let model = FactsDataModel(title: "Test", rows: [DataModelInfoDetails(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")])
        XCTAssertTrue(model.rows[0].title == "Lion")
    }
    func testInfo() {
        let model = DataModelInfoDetails(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")
        XCTAssertFalse(model.imageHref == "https://bbc.com")
        XCTAssertTrue(model.imageHref == "https://abc.com")
    }
    func testDataModelIsValid() {
        let dataModel = FactsDataModel(title: "Welcome", rows: [DataModelInfoDetails(title: nil, description: nil, imageHref: nil)])
        XCTAssertNotNil(dataModel)
    }
}
