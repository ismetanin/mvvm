//
//  Comment.swift
//  mvvm
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let postId: Int
}

extension Comment: Equatable {

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }

}
