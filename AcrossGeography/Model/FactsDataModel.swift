//
//  FactsDataModel.swift
//  AcrossGeography
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation

struct FactsDataModel: Codable {
    // MARK: - Properties
    var title: String
    var rows: [DataModelInfoDetails]
}

struct DataModelInfoDetails: Codable {
    // MARK: - Properties
    var title: String?
    var description: String?
    var imageHref: String?
}

// Created extension so that we can have default memberwise initializer
extension DataModelInfoDetails {
    // MARK: - Initialization
    init?(dataModelInfo: DataModelInfoDetails) {
        guard let title = dataModelInfo.title, let description = dataModelInfo.description, let imageHref = dataModelInfo.imageHref else {
            return
        }
        self.title = title
        self.description = description
        self.imageHref = imageHref
    }
    init(title: String, description: String, imageHref: String) {
        self.title = title
        self.description = description
        self.imageHref = imageHref
    }
}
