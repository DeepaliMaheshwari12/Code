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
    // MARK: - Properties
    var dataModel: DataModel?
    // MARK: - Service Calls
    func fetchData(completion:@escaping (DataModel) -> Void) {

        APIManager().makeRequest {[weak self] (result, _) in

            guard let jsonResult = result else {
                return
            }

            let dataModel = self!.checkForNilObjectInJSON(dataModelObject: jsonResult)
            completion(dataModel)
    }
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
    // MARK: - Business Logic
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
    func provideCellDataAt(indexPath: IndexPath) -> ([String: String]) {

        var values = [String: String]()
        values[Constants.title] = dataModel?.rows[indexPath.row].title
        values[Constants.description] = dataModel?.rows[indexPath.row].description
        values[Constants.image] = dataModel?.rows[indexPath.row].imageHref
        return (values)

    }
    func provideValidURLImage(atIndex: IndexPath, competion: @escaping (UIImage?, Error?) -> Void) {
        guard let imageURL = dataModel?.rows[atIndex.row].imageHref else {
            return
        }
        let changedURL = URL(string: imageURL)
        guard changedURL != nil else {
            return
        }
        imageFrom(url: changedURL!) { (image, error) in
            guard let imageData = image else {
               return competion(nil, error)
            }
            competion(imageData, nil)
        }
    }
}
