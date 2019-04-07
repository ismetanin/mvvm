//
//  Post.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
