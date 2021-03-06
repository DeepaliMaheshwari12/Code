//
//  APIManagerTests.swift
//  AcrossGeographyTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import XCTest
import Alamofire
@testable import AcrossGeography

class APIManagerTests: XCTestCase {
        // MARK: - Service Tests
        func testDataNetworkRequest() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent(Constants.jsonDownloadResponseFile, isDirectory: false)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        let promise = expectation(description: "Get Data")
        Alamofire.download(
            Constants.jsonFileURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (_) in
            }).response(completionHandler: { (defaultDownloadResponse) in
                if defaultDownloadResponse.response?.statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Test Failed")
                }
            })
        waitForExpectations(timeout: 5, handler: nil)

    }
    func testImageDownloadRequest() {
        let promise = expectation(description: "Get image")

        Alamofire.request("http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg")
            .responseData { response in
                if response.response?.statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Test Failed")
                }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
