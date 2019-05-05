//
//  PostListModuleConfigurator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

final class PostListModuleConfigurator {

    func configure() -> (UIViewController, PostListViewModel) {
        let viewModel = PostListViewModel(service: PostsService(session: URLSession.shared))
        let view = PostListViewController(viewModel: viewModel)
        return (UINavigationController(rootViewController: view), viewModel)
    }

}
