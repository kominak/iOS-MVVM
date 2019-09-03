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
    func contactsListCell(_ cell: ContactsListCell, didChangeCheckboxValueTo newValue: Bool)

}

class ContactsListCell: UICollectionViewCell {

    static let cellHeight: CGFloat = 60

    weak var delegate: ContactsListCellDelegate?

    var contact: Contact? {
        didSet {
            guard let contact = self.contact else { return }

            let title = contact.name + (contact.isGoodFriend ? " [BFF]" : "")
            self.titleLabel.text = title
            self.checkbox.isOn = contact.isGoodFriend
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.isUserInteractionEnabled = true

        return label
    }()

    private let checkbox: UISwitch = {
        let view = UISwitch(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressTitle))

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkbox)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.checkbox.leadingAnchor, constant: -16),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            self.checkbox.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.checkbox.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        self.titleLabel.addGestureRecognizer(tapGestureRecognizer)
        self.checkbox.addTarget(self, action: #selector(didChangedCheckbox), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didPressTitle() {
        self.delegate?.contactsListCellDidPressTitle(self)
    }

    @objc private func didChangedCheckbox() {
        self.delegate?.contactsListCell(self, didChangeCheckboxValueTo: self.checkbox.isOn)
    }
}
