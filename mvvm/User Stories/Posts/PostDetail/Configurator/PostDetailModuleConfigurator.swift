//
//  PostDetailModuleConfigurator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 08/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

final class PostDetailModuleConfigurator {

    func configure(with post: Post) -> (UIViewController, PostDetailModuleOutput) {
        let viewModel = PostDetailViewModel(
            post: post,
            usersService: UsersService(),
            commentsService: CommentsService()
        )
        let view = PostDetailViewController(viewModel: viewModel)
        return (view, viewModel)
    }

}
