//
//  InvitedUsersViewController.swift
//  iOS-MVVM
//
//  Created by Marcin Maćkowiak on 30/08/2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit

protocol InvitedUsersViewControllerDelegate: class {

    func invitedUsersViewControllerDidInviteUser(_ viewController: InvitedUsersViewController)

}

class InvitedUsersViewController: UIViewController {

    weak var delegate: InvitedUsersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Invited users"

        self.view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAdd))
    }

    @objc
    private func didPressAdd() {
        let alert = UIAlertController(title: nil, message: "Invited new user", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(confirmAction)

        self.present(alert, animated: true)

        self.delegate?.invitedUsersViewControllerDidInviteUser(self)
    }

}
