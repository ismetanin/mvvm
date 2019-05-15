//
//  User.swift
//  mvvm
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

extension User: Equatable {

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

}
