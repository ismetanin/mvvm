//
//  DataStore.swift
//  mvvm
//
//  Created by Ivan Smetanin on 12/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

protocol DataStore {
    func save(data: Data, from: URLRequest) throws
    func load(from: URLRequest) -> Data?
}
