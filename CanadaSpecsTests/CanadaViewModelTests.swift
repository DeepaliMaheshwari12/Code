//
//  CanadaViewModelTests.swift
//  CanadaSpecsTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import XCTest
@testable import CanadaSpecs

class CanadaViewModelTests: XCTestCase {
    func testViewModelIsValid() {
        let canadaInfo = CanadaInfo(title: "Title", description: "description", imageHref: "https://abc.com")
        let viewModel = CanadaViewModel(info: canadaInfo)
        XCTAssertFalse(viewModel.title == "ValidTitle")
    }
}
