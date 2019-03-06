//
//  ViewModelTestsTests.swift
//  AcrossGeographyTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import XCTest
@testable import AcrossGeography

class ViewModelTests: XCTestCase {
    func testViewModelIsValid() {
        let dataModelInfo = DataModelInfoDetails(title: "Title", description: "description", imageHref: "https://abc.com")
        let viewModel = ViewModel(info: dataModelInfo)
        XCTAssertFalse(viewModel.title == "ValidTitle")
    }
}
