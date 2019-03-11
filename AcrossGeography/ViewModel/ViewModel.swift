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
    var dataModel: FactsDataModel?
    let cache = NSCache<AnyObject, AnyObject>()
    // MARK: - Service Calls
    func fetchData(completion:@escaping (FactsDataModel) -> Void) {

        APIManager().makeRequest {[weak self] (result, error) in
            guard error == nil else {
             return
            }
            let dataModel = self!.checkForNilObjectInJSON(dataModelObject: result!)
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
    func checkForNilObjectInJSON(dataModelObject: FactsDataModel) -> FactsDataModel {
        var jsonResult = dataModelObject

        let itemsNotNil = jsonResult.rows.compactMap { (itemDesc: DataModelInfoDetails) -> DataModelInfoDetails? in
            guard itemDesc.title == nil && itemDesc.description == nil && itemDesc.imageHref == nil else {
                return itemDesc
            }
            return nil
        }
        jsonResult.rows = itemsNotNil
        return jsonResult
    }
    func cellDataAt(indexPath: IndexPath) -> (DataModelInfoDetails) {
        return (DataModelInfoDetails(title: dataModel?.rows[indexPath.row].title,
                                     description: dataModel?.rows[indexPath.row].description,
                                     imageHref: dataModel?.rows[indexPath.row].imageHref))

    }
    func provideValidURLImage(atIndex: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let image = imageFromCache(indexPath: atIndex)
        if image != nil {
            completion(image)
            return
        }
        guard let imageURL = dataModel?.rows[atIndex.row].imageHref else {
            return
        }
        let changedURL = URL(string: imageURL)
        guard changedURL != nil else {
            return
        }
        imageFrom(url: changedURL!) { (image, _) in
            guard let imageData = image else {
               return completion(nil)
            }
            self.cache.setObject(imageData, forKey: (atIndex as NSIndexPath).row as AnyObject)
            completion(imageData)
            }
        }
    func imageFromCache(indexPath: IndexPath) -> (UIImage?) {
        if cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil {
            // Use cache
            return (cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage)!
        } else {
            return nil
        }
    }
}
