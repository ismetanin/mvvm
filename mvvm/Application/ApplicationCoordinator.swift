//
//  ApplicationCoordinator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {

    // MARK: - Nested types

    private enum LaunchInstructor {
        case posts

        static func configure() -> LaunchInstructor {
            return .posts
        }
    }

    // MARK: - Properties

    private var instructor: LaunchInstructor {
        let instructor = LaunchInstructor.configure()
        return instructor
    }

    private var isAuthorized = false

    // MARK: - Initialization

    override func start() {
        switch instructor {
        case .posts:
            runPostsFlow()
        }
    }

    // MARK: - Private methods

    private func runPostsFlow() {
        let router = MainRouter()
        let (view, viewModel) = PostListModuleConfigurator().configure()
        router.setRootModule(view)
    }

}
