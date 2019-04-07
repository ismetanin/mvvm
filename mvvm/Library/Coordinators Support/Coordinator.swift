//
//  Coordinator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

/// Base protocol for coordinator
protocol Coordinator: class {
    /// Notifies coordinator that it can start itself
    func start()
}
