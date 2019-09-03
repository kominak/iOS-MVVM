//
//  Networking.swift
//  iOS-MVVM
//
//  Created by Oto Kominak on 03.09.2019.
//  Copyright © 2019 MeWe. All rights reserved.
//

import Foundation
import PromiseKit

class Networking {

    static let shared = Networking()

    enum NetworkingError: Error {
        case savingContactFailed
    }

    func loadContacts() -> Promise<[Contact]> {
        return after(seconds: 2)
        .map { _ -> [Contact] in
            Array(1...40).map({
                return Contact(
                    id: UUID(),
                    name: "Contact \($0)",
                    isGoodFriend: $0.quotientAndRemainder(dividingBy: 7).remainder == 0
                )
            })
        }
    }

    func saveContact(_ contact: Contact) -> Promise<Void> {

        return after(seconds: 1)
        .done {
            guard (0..<10).randomElement() ?? 0 >= 5 else {
                NSLog("🎇 Saving contact details failed...")
                throw NetworkingError.savingContactFailed
            }

            NSLog("🎖 Saving succeeded!")
        }
    }
}
