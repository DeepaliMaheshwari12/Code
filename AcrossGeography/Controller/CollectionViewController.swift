//
//  CollectionViewController.swift
//  UICollectionViewExample
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    let apiManager = APIManager()
    var refreshCtrl: UIRefreshControl!
    var cache: NSCache<AnyObject, AnyObject>!
    var viewModel: ViewModel!
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: CGFloat(Float(Constants.collectionViewEstimatedSizeHeight)))
        return layout
    }()
    let customCellIdentifier = Constants.collectionViewCellIdentifier
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Creating the refresh functionality
        refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action: #selector(fetchDataFromViewModel), for: .valueChanged)
        collectionView.backgroundColor = UIColor.blue
        collectionView.register(BasicCollectionCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        collectionView?.collectionViewLayout = layout
        cache = NSCache()
        // Fetching the data on launch
        viewModel = ViewModel()
        fetchDataFromViewModel()
    }
    // MARK: - Fetch Data
    @objc fileprivate func fetchDataFromViewModel() {

        viewModel.callWebAPIforJSONFile { (response) in
        self.viewModel.dataModel = response
        DispatchQueue.main.async {
            self.setupNavBar()
            self.collectionView.reloadData()
        }
    }
}
    // MARK: - Set Navigation Bar
    fileprivate func setupNavBar() {
        navigationItem.title = viewModel.dataModel?.title
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
    }
    // MARK: - Delegate and Datasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewDataModelCheck = viewModel, let viewDataModel = viewDataModelCheck.dataModel else {
            return 0
        }
        return viewDataModel.rows.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as? BasicCollectionCell
        customCell?.label.text = viewModel.dataModel?.rows[indexPath.row].title ?? ""
        customCell?.detailLabel.text = viewModel.dataModel?.rows[indexPath.row].description ?? ""
        customCell?.imageView.image = nil
        if cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil {
            // Use cache
            customCell?.imageView.image = cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        } else {
            let imageURL = viewModel.dataModel?.rows[indexPath.row].imageHref ?? ""
            let url: URL! = URL(string: imageURL)
            guard url != nil else {
                return customCell!
            }
            viewModel.imageFrom(url: url) { (downloadedImage, _) in
                guard let image = downloadedImage else {
                    return
                }
                    DispatchQueue.main.async(execute: { () -> Void in
                        if collectionView.indexPath(for: customCell!)?.row == indexPath.row {
                            let img: UIImage! = image
                            customCell!.imageView.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        }
                    })
            }

        }
        return customCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            let padding: CGFloat =  CGFloat(Float(Constants.iPadPadding))
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
        return collectionView.frame.size

    }
    // MARK: - Orientation Methods 
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
