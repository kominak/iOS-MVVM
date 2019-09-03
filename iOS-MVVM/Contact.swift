//
//  Contact.swift
//  iOS-MVVM
//
//  Created by Oto Kominak on 03.09.2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import Foundation
import IGListKit

// This is a class on purpose - similar to CoreData / NSManagedObject subclasses, sharing state...
class Contact {

    let id: UUID
    var name: String
    var isGoodFriend: Bool

    init(id: UUID, name: String, isGoodFriend: Bool) {
        self.id = id
        self.name = name
        self.isGoodFriend = isGoodFriend
    }
}

extension Contact: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return "Contact:\(self.id.uuidString)" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let otherContact = object as? Contact else { return false }

        return
            self.id == otherContact.id &&
            self.name == otherContact.name &&
            self.isGoodFriend == otherContact.isGoodFriend
    }

}
