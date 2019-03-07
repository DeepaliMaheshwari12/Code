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
        XCTAssertTrue(modelData.rows[0].description == "description")
    }
    func testDataModelBusinessLogic() {
        let dataModelInfo1 = DataModelInfoDetails(title: "Title", description: "description", imageHref: "https://abc.com")
        let dataModelInfo2 = DataModelInfoDetails(title: nil, description: nil, imageHref: nil)
        let dataModelInfo3 = DataModelInfoDetails(title: "Title", description: "description", imageHref: "https://abc.com")
        let modelData = DataModel(title: "Welcome", rows: [dataModelInfo1, dataModelInfo2, dataModelInfo3])
        let remainingObject = viewModel.checkForNilObjectInJSON(dataModelObject: modelData)
        XCTAssertFalse(remainingObject.rows.count == modelData.rows.count)
    }
    func testJSONFileServiceClosure() {
        let expectation = self.expectation(description: "Will Download Json")
        APIManager().makeRequest {(result, _) in
            guard let jsonResult = result else {
                return
            }
            XCTAssertNotNil(jsonResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

    }
    func testImageDownloadClosure() {
        let expectation = self.expectation(description: "Will Download Image")
        APIManager().imageFrom(url: URL(string: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg")!) { (downloadedImage, error) in
            if error != nil {
                fatalError()
            }
            guard let image = downloadedImage else {
                return
            }
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
