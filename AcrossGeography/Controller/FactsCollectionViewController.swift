//
//  FactsCollectionViewController.swift
//  UICollectionViewExample
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import UIKit

class FactsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    private let apiManager = APIManager()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    private var cache: NSCache<AnyObject, AnyObject>!
    var viewModel: ViewModel!
    private var activityView: UIActivityIndicatorView!
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: CGFloat(Float(Constants.collectionViewEstimatedSizeHeight)))
        return layout
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creating the refresh functionality
        refreshControl.addTarget(self, action: #selector(fetchDataFromViewModel), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = UIColor.lightGray
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        collectionView.register(FactsBasicCollectionCell.self, forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        collectionView?.collectionViewLayout = layout
        cache = NSCache()
        // Fetching the data on launch
        viewModel = ViewModel()
        fetchDataFromViewModel()
    }
    // MARK: - Fetch Data
    @objc fileprivate func fetchDataFromViewModel() {
        if Reachability.isConnectedToNetwork() == true {
            viewModel.fetchData { (response) in
                self.viewModel.dataModel = response
                DispatchQueue.main.async {
                    self.setupNavBar()
                    self.activityView.stopAnimating()
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        } else {
            self.activityView.stopAnimating()
            throwAlertMessage()
            self.refreshControl.endRefreshing()
        }
    }
    // MARK: - Set Navigation Bar
    fileprivate func setupNavBar() {
        navigationItem.title = viewModel.dataModel?.title
        navigationController?.navigationBar.backgroundColor = .lightGray
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
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIdentifier, for: indexPath) as? FactsBasicCollectionCell
        let dataToDisplay = viewModel.cellDataAt(indexPath: indexPath)
        customCell?.label.text = dataToDisplay.title
        customCell?.label.font = UIFont(name: "Helvetica-Bold", size: Constants.customCellTextLabelFont)
        customCell?.detailLabel.text = dataToDisplay.description
        customCell?.imageView.image = nil
        if Reachability.isConnectedToNetwork() == true {
            viewModel.provideValidURLImage(atIndex: indexPath) { (image) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if collectionView.indexPath(for: customCell!)?.row == indexPath.row {
                        customCell?.imageView.image = image
                    }
                })
            }
        } else {
            throwAlertMessage()
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
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: Constants.collectionViewLayoutheight)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: Constants.collectionViewLayoutheight)
        layout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    // MARK: - Alert
    func throwAlertMessage() {
        let alertController = UIAlertController(title: Constants.networkFailureTitle, message: Constants.networkFailureMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okMessage, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
