//
//  PostDetailModuleConfigurator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 08/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

final class PostDetailModuleConfigurator {

    func configure() -> (UIViewController, PostDetailModuleOutput) {
        let viewModel = PostDetailViewModel(service: PostsService())
        let view = PostDetailViewController(viewModel: viewModel)
        return (view, viewModel)
    }

}
