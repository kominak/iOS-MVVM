//
//  FirstViewControllerListCell.swift
//  iOS-MVVM
//
//  Created by Marcin Maćkowiak on 29/08/2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit

protocol ContactsListCellDelegate: class {

    func contactsListCellDidPressTitle(_ cell: ContactsListCell)

}

class ContactsListCell: UICollectionViewCell {

    static let cellHeight: CGFloat = 60

    weak var delegate: ContactsListCellDelegate?

    var title: String? {
        didSet {
            guard let order = self.title else { return }

            self.titleLabel.text = "Contact \(order)"
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.isUserInteractionEnabled = true

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressTitle))

        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.titleLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didPressTitle() {
        self.delegate?.contactsListCellDidPressTitle(self)
    }

}
