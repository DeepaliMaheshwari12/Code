//
//  Constants.swift
//  AcrossGeography
//
//  Created by GtoMobility on 07/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import CoreGraphics
struct Constants {

    static let jsonDownloadResponseFile = "facts.json"
    static let jsonFileURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let collectionViewCellIdentifier = "customCellIdentifier"
    static let collectionViewEstimatedSizeHeight = 10
    static let factsTitle = "title"
    static let factsDescription = "description"
    static let factsImage = "imageHref"
    static let placeHolderImage = "placeholder.jpg"
    static let networkFailureTitle = "Network Failure"
    static let networkFailureMessage = "Please check your network connection."
    static let collectionViewLayoutheight: CGFloat = 10.0
    static let customCellTextLabelFont: CGFloat = 16
    static let okMessage = "OK"
}

struct CellLayoutsSize {

    static let topAnchorConstraint: CGFloat = 10
    static let rightAnchorConstraint: CGFloat = 20
    static let widthAndHeightAnchorConstraint: CGFloat = 250
}
