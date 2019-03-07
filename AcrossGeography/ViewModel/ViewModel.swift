//
//  ViewModel.swift
//  AcrossGeography
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import UIKit

class ViewModel {

    var dataModel: DataModel?

    func callWebAPIforJSONFile(completion:@escaping (DataModel) -> Void) {

        APIManager().makeRequest {[weak self] (result, _) in

            guard let jsonResult = result else {
                return
            }

            let dataModel = self!.checkForNilObjectInJSON(dataModelObject: jsonResult)
            completion(dataModel)
    }
}
    func checkForNilObjectInJSON(dataModelObject: DataModel) -> DataModel {
        var jsonResult = dataModelObject

        let itemsNotNil = jsonResult.rows.compactMap { (itemDesc: DataModelInfoDetails) -> DataModelInfoDetails? in
            if itemDesc.title == nil && itemDesc.description == nil && itemDesc.imageHref == nil {
                return nil
            }
            return itemDesc
        }
        jsonResult.rows = itemsNotNil
        return jsonResult
        }
    func imageFrom(url: URL,
                   completionHandler: @escaping (UIImage?, Error?) -> Void) {
        APIManager().imageFrom(url: url) { (downloadedImage, error) in
            if error != nil {
                fatalError()
            }
            guard let image = downloadedImage else {
                return
            }
            completionHandler(image, error)
        }
    }
    }
