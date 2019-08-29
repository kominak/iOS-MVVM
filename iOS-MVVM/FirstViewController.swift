//
//  FirstViewController.swift
//  iOS-MVVM
//
//  Created by Marcin Maćkowiak on 29/08/2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import UIKit
import IGListKit

class FirstViewController: UIViewController {

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

        self.title = "List"
        
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
    }

}

// MARK: - ListAdapterDataSource

extension FirstViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return Array(1...40).map({ String($0) as NSString })
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is String {
            return ListSingleSectionController(
                cellClass: FirstViewControllerListCell.self,
                configureBlock: { (object, cell) in
                    guard
                        let firstListCell = cell as? FirstViewControllerListCell,
                        let order = object as? String
                    else {
                        return
                    }

                    firstListCell.title = order
                    firstListCell.delegate = self
                }, sizeBlock: { (object, collectionContext) -> CGSize in
                    return CGSize(width: collectionContext!.containerSize.width, height: FirstViewControllerListCell.cellHeight)
                }
            )
        }

        fatalError("Unknown object type provided by the list adapter")
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension FirstViewController: FirstViewControllerListCellDelegate {

    func firstViewControllerListCellDidPressTitle(_ cell: FirstViewControllerListCell) {
        guard let title = cell.title else { return }

        let alert = UIAlertController(title: nil, message: "Pressed title: \(title)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(confirmAction)

        self.present(alert, animated: true)
    }

}
