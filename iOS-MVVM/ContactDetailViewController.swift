//
//  ContactDetailViewController.swift
//  iOS-MVVM
//
//  Created by Oto Kominak on 03.09.2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit
import PromiseKit

protocol ContactDetailViewControllerDelegate: class {
    func contactDetailViewController(_ viewController: ContactDetailViewController, didUpdate contact: Contact)
}

class ContactDetailViewController: UIViewController {

    private let contact: Contact
    weak var delegate: ContactDetailViewControllerDelegate? = nil

    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center

        return label
    }()

    private let goodFriendSwitch: UISwitch = {
        let view = UISwitch(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.goodFriendSwitch)

        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            self.goodFriendSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.goodFriendSwitch.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16)
        ])

        self.nameLabel.text = self.contact.name
        self.goodFriendSwitch.isOn = self.contact.isGoodFriend

        self.goodFriendSwitch.addTarget(self, action: #selector(goodFriendSwitched), for: .valueChanged)
    }

    @objc private func goodFriendSwitched() {
        let oldValue = self.contact.isGoodFriend

        self.contact.isGoodFriend = self.goodFriendSwitch.isOn

        Networking.shared.saveContact(self.contact)
        .done { _ in
            self.delegate?.contactDetailViewController(self, didUpdate: self.contact)
        }
        .catch { _ in
            self.contact.isGoodFriend = oldValue
            self.goodFriendSwitch.isOn = oldValue

            let alert = UIAlertController(title: "Failure", message: "Saving details for \(self.contact.name) failed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "What can one do...", style: .default))

            self.present(alert, animated: true)
        }
    }

}
