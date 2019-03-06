//
//  ViewController.swift
//  UICollectionViewExample
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import UIKit

class CustomViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var canadaViewModel: CanadaModel?
    let apiManager = APIManager()
    var refreshCtrl: UIRefreshControl!
    var cache:NSCache<AnyObject, AnyObject>!

    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    
    let customCellIdentifier = "customCellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Creating the refresh functionality
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.collectionView.backgroundColor = UIColor.blue
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        collectionView?.collectionViewLayout = layout
        self.cache = NSCache()
        
        // Fetching the data on launch
        fetchData()

    }
    
    @objc fileprivate func fetchData() {
        
        apiManager.makeRequest {[weak self] (responseData, error) in
            if let error = error {
                print("Failed to fetch courses:", error)
                return
            }
            self!.canadaViewModel = responseData
            
            DispatchQueue.main.async {
                self?.setupNavBar()
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = self.canadaViewModel?.title
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return canadaViewModel?.rows.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
        customCell.label.text = canadaViewModel?.rows[indexPath.row].title ?? ""
        customCell.detailLabel.text = canadaViewModel?.rows[indexPath.row].description ?? ""
        customCell.imageView.image = nil
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            customCell.imageView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            // 3
            let imageURL = canadaViewModel?.rows[indexPath.row].imageHref ?? ""
            let url:URL! = URL(string: imageURL)
            guard url != nil else {
                return customCell
            }

            apiManager.imageFrom(url: url) { (image, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if let error = error {
                        print("Failed to fetch image:", error)
                        return
                    }
                    if image == nil {
                        return
                    }
                    if collectionView.indexPath(for: customCell)?.row == indexPath.row {
                        let img:UIImage! = image
                        customCell.imageView.image = img
                        self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                })
            }

        }
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding
        
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
        
        
        return collectionView.frame.size

    }
    
    // Orientation Methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        layout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}

