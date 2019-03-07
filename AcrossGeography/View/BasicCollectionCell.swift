//
//  BasicCollectionCell.swift
//  AcrossGeography
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import UIKit

class BasicCollectionCell: UICollectionViewCell {
    // MARK: - Properties
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        return detailLabel
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.placeHolderImage))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.darkGray
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Cell Layout
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    private func setupViews() {
        let margins = contentView.layoutMarginsGuide
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor).isActive = true
        contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: imageView.frame.width ).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        contentView.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: imageView.frame.width).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        }
    }
}
