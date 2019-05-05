//
//  BaseCoordinator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

/// Provides base realisation of coordinator's methods
/// Subclass from this base class for making new flow coordinator
class BaseCoordinator: Coordinator {

    // MARK: - Properties

    var childCoordinators: [Coordinator] = []

    func start() {}

    func addDependency(_ coordinator: Coordinator) {
        // add only unique object
        guard !hasSameDependency(coordinator) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard
            !childCoordinators.isEmpty,
            let coordinator = coordinator
        else {
            return
        }

        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func removeAllChilds() {
        guard
            !childCoordinators.isEmpty
        else {
            return
        }

        for coordinator in childCoordinators {
            if let coordinator = coordinator as? BaseCoordinator {
                coordinator.removeAllChilds()
            }
        }

        childCoordinators.removeAll()
    }

    func hasDependency<T>(ofType: T.Type) -> Coordinator? {
        guard
            !childCoordinators.isEmpty
        else {
            return nil
        }

        for coordinator in childCoordinators {
            if coordinator is T {
                return coordinator
            }
        }

        return nil
    }

    // MARK: - Private methods

    private func hasSameDependency(_ coordinator: Coordinator) -> Bool {
        for element in childCoordinators {
            if element === coordinator {
                return true
            }
        }
        return false
    }

}
