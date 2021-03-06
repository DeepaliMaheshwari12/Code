//
//  APIManager.swift
//  AcrossGeography
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class APIManager {
    // Downloading image from server using AlamofireImage
    func imageFrom(url: URL,
                   completionHandler: @escaping (UIImage?, Error?) -> Void) {
        Alamofire.request(url)
            .responseData { response in
                guard let data = response.data else {
                    completionHandler(nil, response.error)  //Handling error condition
                    return }
                let image = UIImage(data: data)
                completionHandler(image, nil)
        }
    }
    // Downloading JSON file from server and reading the contents of file
    func makeRequest(completion:@escaping (FactsDataModel?, Error?) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent(Constants.jsonDownloadResponseFile, isDirectory: false)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        Alamofire.download(
            Constants.jsonFileURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { _ in
            }).response(completionHandler: { (response) in
                if let statusCode = response.response?.statusCode, statusCode == 200 {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                let plistPath = paths.appendingPathComponent(Constants.jsonDownloadResponseFile)
                    do {
                        let data1 = try Data(contentsOf: URL(fileURLWithPath: plistPath), options: .mappedIfSafe)
                        let string = String(decoding: data1, as: UTF8.self)
                        if !string.isEmpty {
                            let data = string.data(using: .utf8)!
                            let jsonResult = try JSONDecoder().decode(FactsDataModel.self, from: data)
                            completion(jsonResult, nil)
                        }
                        return
                       } catch let error {
                            completion(nil, error)
                    }
                }
                completion(nil, response.error)
            }
        )
    }

}
