//
//  PostListViewModel.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PostListViewModel: ViewModel {

    // MARK: - Nested types

    struct Input {
        let ready: Driver<Void>
        let showPost: Driver<IndexPath>
    }

    struct Output {
        let list: Driver<[Post]>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
    }

    // MARK: - Properties

    private let service: PostsAbstractService

    // MARK: - Initialization and deinitialization

    init(service: PostsAbstractService) {
        self.service = service
    }

    // MARK: - ViewModel

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let postsList = input.ready
            .flatMapLatest { _ in
                return self.service.getPosts()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }

        let error = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()

        return Output(list: postsList, error: error, isLoading: isLoading)
    }

}
