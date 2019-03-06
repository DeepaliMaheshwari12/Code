//
//  CanadaViewModel.swift
//  CanadaSpecs
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation

class CanadaViewModel {
    let title: String
    let detailDescripion: String
    let imageURL: String
    // Dependency Injection (DI)
    init(info: CanadaInfo) {
        self.title = info.title ?? ""
        self.detailDescripion = info.description ?? ""
        self.imageURL = info.imageHref ?? ""

    }
}
