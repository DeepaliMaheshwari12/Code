//
//  ViewControllerTests.swift
//  AcrossGeographyTests
//
//  Created by GtoMobility on 06/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import UIKit
@testable import AcrossGeography
import XCTest

class ViewControllerTests: XCTestCase {
    var customCell: BasicCollectionCell?
    var collectionViewController: CollectionViewController!
    override func setUp() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionViewController = CollectionViewController(collectionViewLayout: flowLayout)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCollectionViewControllerNotNil() {
        XCTAssertNotNil(collectionViewController)
    }
    func testViewControllerModelView() {
        let model = [DataModelInfoDetails(title: "Flag", description: "National Flag", imageHref: "http://abc.c"), DataModelInfoDetails(title: "Fruit", description: "Mango", imageHref: "http://xyz")]
        collectionViewController.viewModel?.dataModel?.rows =  model
        XCTAssertFalse(collectionViewController.viewModel?.dataModel!.rows[1].description == "kkkk")
    }
    func testViewIsNotNilAfterViewDidLoad() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionViewController = CollectionViewController(collectionViewLayout: flowLayout)
        XCTAssertNotNil(collectionViewController.collectionView)
    }
    func testCollectionViewDataSource() {
        XCTAssertNotNil(collectionViewController.collectionView.dataSource)
    }
    func testConformsToCollectionViewDataSource() {
        XCTAssert(collectionViewController.conforms(to: UICollectionViewDataSource.self))
    }
    func testShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(collectionViewController.collectionView.delegate)
    }
    func testConformsToCollectionViewDelegate() {
        XCTAssert(collectionViewController.conforms(to: UICollectionViewDelegate.self))
    }
    func testNavigationTitle() {
        let title = "About Cananda"
        collectionViewController.navigationItem.title = title
        XCTAssertNotNil(collectionViewController.navigationItem.title)
    }
    func testCustomCell() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        let cell = collectionViewController.collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath as IndexPath) as? BasicCollectionCell
        cell?.detailLabel.text = "Detailed Text"
        XCTAssertNotNil(cell?.detailLabel.text)
    }
}
