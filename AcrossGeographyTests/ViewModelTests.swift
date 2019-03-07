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
    var viewModel = ViewModel()
    func testViewModelIsValid() {
        let dataModelInfo = DataModelInfoDetails(title: "Title", description: "description", imageHref: "https://abc.com")
        let modelData = DataModel(title: "Welcome", rows: [dataModelInfo])

        viewModel.dataModel?.title = modelData.title
        viewModel.dataModel?.rows = [dataModelInfo]
        XCTAssertFalse(viewModel.dataModel?.title == "ValidTitle")
    }
}
