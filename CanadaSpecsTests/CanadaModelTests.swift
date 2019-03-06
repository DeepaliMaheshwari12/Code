//
//  CanadaModelTests.swift
//  CanadaSpecsTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import XCTest
@testable import CanadaSpecs

class CanadaModelTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
}
    func testCanadaModelIsInvalid() {
        
        
        let canadaModel = CanadaModel(title: "Test", rows: [CanadaInfo(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")])
        XCTAssertNotNil(canadaModel.rows[0].title)
    }
    func testCanadaModelIsValid() {
        
        
        let canadaModel = CanadaModel(title: "Test", rows: [CanadaInfo(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")])
        XCTAssertTrue(canadaModel.rows[0].title == "Lion")
    }
    
    func testCanadaInfo() {
        
        let canadaModel = CanadaInfo(title: "Lion", description: "Big Cat", imageHref: "https://abc.com")

        XCTAssertFalse(canadaModel.imageHref == "https://bbc.com")
        XCTAssertTrue(canadaModel.imageHref == "https://abc.com")

    }
    
}
