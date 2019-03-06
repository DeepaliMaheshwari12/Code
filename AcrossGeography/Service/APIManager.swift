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
    func makeRequest(completion:@escaping (DataModel?, Error?) -> Void) {

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent("facts.json", isDirectory: false)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }

        Alamofire.download(
            "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                print(progress)

            }).response(completionHandler: { (defaultDownloadResponse) in
                print(defaultDownloadResponse.response?.statusCode as Any)
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                // This code has be to be fixed. It is giving error in parsing facts.json
                do {
                    try FileManager.default.copyfileToUserDocumentDirectory(forResource: "Contents", ofType: "json")
                } catch let error {
                        print(error)
                }
                let plistPath = paths.appendingPathComponent("Contents.json")

                    do {
                         let data = try Data(contentsOf: URL(fileURLWithPath: plistPath), options: [])
                        var jsonResult = try JSONDecoder().decode(DataModel.self, from: data)
                        //Has to do compact map to remove nil values
                        let itemsNotNil = jsonResult.rows.compactMap { (itemDesc: DataModelInfoDetails) -> DataModelInfoDetails? in
                            if itemDesc.title == nil && itemDesc.description == nil && itemDesc.imageHref == nil {
                                return nil
                            }
                                return itemDesc
                        }
                        jsonResult.rows = itemsNotNil
                        completion(jsonResult, nil)
                       } catch let error {
                            completion(nil, error)
                    }

            })

    }

}

// This is temporary method and will be removed
extension FileManager {
    func copyfileToUserDocumentDirectory(forResource name: String,
                                         ofType ext: String) throws {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: ext),
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask,
                                                               true).first {
            let fileName = "\(name).\(ext)"
            let fullDestPath = URL(fileURLWithPath: destPath)
                .appendingPathComponent(fileName)
            let fullDestPathString = fullDestPath.path
            if !self.fileExists(atPath: fullDestPathString) {
                try self.copyItem(atPath: bundlePath, toPath: fullDestPathString)
            }
        }
    }
}
