//
//  ContactsListViewController.swift
//  iOS-MVVM
//
//  Created by Marcin Maćkowiak on 29/08/2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit
import IGListKit

class ContactsListViewController: UIViewController {

    private var contacts: [Contact] = []

    private lazy var adapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView = {
        let layout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contacts list"

        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self

        Networking.shared.loadContacts()
        .done { contacts in
            self.contacts = contacts
            self.adapter.performUpdates(animated: true)
        }
        .cauterize()
    }

}

// MARK: - ListAdapterDataSource

extension ContactsListViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.contacts
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Contact {
            return ListSingleSectionController(
                cellClass: ContactsListCell.self,
                configureBlock: { [weak self] (object, cell) in
                    guard
                        let cell = cell as? ContactsListCell,
                        let object = object as? Contact
                    else {
                        return
                    }

                    cell.contact = object
                    cell.delegate = self
                },
                sizeBlock: { (object, collectionContext) -> CGSize in
                    return CGSize(width: collectionContext!.containerSize.width, height: ContactsListCell.cellHeight)
                }
            )
        }

        fatalError("Unknown object type provided by the list adapter")
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let view = UIActivityIndicatorView(style: .gray)
        view.startAnimating()
        return view
    }

}

extension ContactsListViewController: ContactsListCellDelegate {

    func contactsListCell(_ cell: ContactsListCell, didChangeCheckboxValueTo newValue: Bool) {
        guard let contact = cell.contact else { return }

        let oldValue = contact.isGoodFriend

        contact.isGoodFriend = newValue

        Networking.shared.saveContact(contact)
        .catch { _ in
            contact.isGoodFriend = oldValue

            let alert = UIAlertController(title: "Failure", message: "Saving details for \(contact.name) failed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "What can one do...", style: .default))

            self.present(alert, animated: true)
        }
        .finally {
            // TODO: Ideally reload only relevant cells - not doable with shared state, though.
            self.adapter.reloadData()
        }
    }

    func contactsListCellDidPressTitle(_ cell: ContactsListCell) {
        guard let contact = cell.contact else { return }

        let detailViewController = ContactDetailViewController(contact: contact)
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}

extension ContactsListViewController: ContactDetailViewControllerDelegate {

    func contactDetailViewController(_ viewController: ContactDetailViewController, didUpdate contact: Contact) {
        // TODO: Ideally reload only relevant cells - not doable with shared state, though.
        self.adapter.reloadData()
    }

}
