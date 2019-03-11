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
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        return refreshControl
    }()
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
        // Fetching the data on launch
        viewModel = ViewModel()
        viewModel.delegate = collectionView.delegate
        viewModel.datasource = collectionView.dataSource
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
       return viewModel.collectionView(collectionView, numberOfItemsInSection: section)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.collectionView(collectionView, cellForItemAt: indexPath)
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    // MARK: - Alert
    func throwAlertMessage() {
        let alertController = UIAlertController(title: Constants.networkFailureTitle, message: Constants.networkFailureMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okMessage, style: .default, handler: {_ in
            self.refreshControl.endRefreshing()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// Extension written to handle orientation issues
extension FactsCollectionViewController {
    // MARK: - Orientation Methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
                self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
            else {
                return
        }
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.estimateVisibleCellSizes(to: size)
        coordinator.animate(alongsideTransition: { _ in
        }, completion: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    func preferredWith(forSize size: CGSize) -> CGFloat {
        let columnFactor: CGFloat = 1.0
        return (size.width - 30) / columnFactor
    }
    func estimateVisibleCellSizes(to size: CGSize) {
        guard let collectionView = self.collectionView else {
            return
        }
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: size), height: 1)
        }
        collectionView.visibleCells.forEach({ cell in
            if let cell = cell as? FactsBasicCollectionCell {
                cell.setPreferred(width: self.preferredWith(forSize: size))
            }
        })
    }

}
