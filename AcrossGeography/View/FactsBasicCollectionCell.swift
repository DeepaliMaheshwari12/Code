//
//  FactsBasicCollectionCell.swift
//  AcrossGeography
//
//  Created by GtoMobility on 05/03/19.
//  Copyright © 2019 GtoMobility. All rights reserved.
//

import Foundation
import UIKit

class FactsBasicCollectionCell: UICollectionViewCell {
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellLayoutsSize.topAnchorConstraint).isActive = true
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CellLayoutsSize.widthAndHeightAnchorConstraint).isActive = true
        contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: CellLayoutsSize.topAnchorConstraint).isActive = true
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        contentView.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: CellLayoutsSize.topAnchorConstraint).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true

        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: CellLayoutsSize.topAnchorConstraint).isActive = true
        }
    }
    func setPreferred(width: CGFloat) {
        self.label.preferredMaxLayoutWidth = width
        self.detailLabel.preferredMaxLayoutWidth = width
    }
}
