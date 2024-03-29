//
//  ContactsSettingsViewController.swift
//  iOS-MVVM
//
//  Created by Marcin Maćkowiak on 29/08/2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit
import PromiseKit

class ContactsSettingsViewController: UIViewController {

    typealias Settings = (canBeInvited: Bool, invitationsCount: Int)

    enum State {
        case loading
        case ready(Settings)
    }

    private var state: State = .loading {
        didSet {
            switch self.state {
            case .loading:
                self.activityIndicatorView.startAnimating()

                self.canInviteLabel.isHidden = true

                self.canInviteSwitch.isHidden = true

                self.invitationsLabel.isHidden = true

            case .ready(let settings):
                self.activityIndicatorView.stopAnimating()

                self.canInviteLabel.isHidden = false

                self.canInviteSwitch.isHidden = false
                self.canInviteSwitch.isOn = settings.canBeInvited

                self.invitationsLabel.isHidden = false
                self.invitationsLabel.text = "Invited users: \(String(settings.invitationsCount))"
            }
        }
    }

    private let canInviteLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "User accepts invitations:"

        return label
    }()

    private let canInviteSwitch: UISwitch = {
        let switchControl = UISwitch(frame: .zero)

        switchControl.translatesAutoresizingMaskIntoConstraints = false

        return switchControl
    }()

    private let invitationsLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Invited users:"

        return label
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true

        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contacts settings"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invitations", style: .plain, target: self, action: #selector(didPressInvite))

        self.view.addSubview(self.canInviteLabel)
        self.view.addSubview(self.canInviteSwitch)
        self.view.addSubview(self.invitationsLabel)
        self.view.addSubview(self.activityIndicatorView)

        NSLayoutConstraint.activate([
            self.canInviteLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.canInviteLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.canInviteLabel.heightAnchor.constraint(equalTo: self.canInviteSwitch.heightAnchor, constant: 0)
        ])

        NSLayoutConstraint.activate([
            self.canInviteSwitch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.canInviteSwitch.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.canInviteSwitch.leadingAnchor.constraint(greaterThanOrEqualTo: self.canInviteLabel.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            self.invitationsLabel.topAnchor.constraint(equalTo: self.canInviteLabel.bottomAnchor, constant: 16),
            self.invitationsLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.invitationsLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])

        self.state = .loading

        self.getContactsSettings()
        .done { response in
            self.state = .ready(response)

            self.persist(settings: response)
        }
        .ensure {
            self.activityIndicatorView.stopAnimating()
        }
        .cauterize()
    }

    @objc
    private func didPressInvite() {
        let invitedUsersViewController = InvitedUsersViewController()

        invitedUsersViewController.delegate = self

        self.navigationController?.pushViewController(invitedUsersViewController, animated: true)
    }

    // MARK: - Data

    private func getContactsSettings() -> Promise<Settings> {
        return after(seconds: 3)
        .then {
            return Promise.value((canBeInvited: true, invitationsCount: 5))
        }
    }

    private func persist(settings: Settings) {
        // save settings to persistent store
    }

}

extension ContactsSettingsViewController: InvitedUsersViewControllerDelegate {

    func invitedUsersViewControllerDidInviteUser(_ viewController: InvitedUsersViewController) {
        switch self.state {
        case .ready(let settings):
            self.state = .ready((canBeInvited: settings.canBeInvited, invitationsCount: settings.invitationsCount + 1))
            
        case .loading:
            break
        }
    }

}
