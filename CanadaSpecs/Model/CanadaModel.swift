//
//  CanadaModel.swift
//  CanadaSpecs
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation

struct CanadaModel: Codable {
    var title: String
    var rows: [CanadaInfo]
}

struct CanadaInfo: Codable {
    var title: String?
    var description: String?
    var imageHref: String?
}

// Created extension so that we can have default memberwise initializer
extension CanadaInfo {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let title: String? = try values.decodeIfPresent(String.self, forKey: .title)
        let description: String? = try values.decodeIfPresent(String.self, forKey: .description)
        let imageHref: String? = try values.decodeIfPresent(String.self, forKey: .imageHref)
        self.title = title
        self.description = description
        self.imageHref = imageHref
    }
    init?(canadaInfo: CanadaInfo) {
        guard let title = canadaInfo.title, let description = canadaInfo.description, let imageHref = canadaInfo.imageHref else {
            return
        }
        self.title = title
        self.description = description
        self.imageHref = imageHref
    }

}
