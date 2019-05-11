//
//  PostDetailViewModel.swift
//  mvvm
//
//  Created by Ivan Smetanin on 10/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PostDetailViewModel: ViewModel, PostDetailModuleOutput {

    // MARK: - Nested types

    struct Input {
        let ready: Driver<Void>
    }

    struct Output {}

    // MARK: - Properties

    private let service: PostsAbstractService

    // MARK: - Initialization and deinitialization

    init(service: PostsAbstractService) {
        self.service = service
    }

    // MARK: - ViewModel

    func transform(input: Input) -> Output {
        return Output()
    }

}
