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

final class PostListViewModel: ViewModel, PostListModuleOutput {

    // MARK: - PostListModuleOutput

    var onShowDetail: ((Post) -> Void)?

    // MARK: - Nested types

    struct Input {
        let ready: Driver<Void>
        let showPost: Driver<IndexPath>
    }

    struct Output {
        let posts: Driver<[Post]>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let selectedPost: Driver<Post>
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

        let selectedPost = input.showPost
            .withLatestFrom(postsList) { (indexPath, posts) -> Post in
                return posts[indexPath.row]
            }
            .do(onNext: showPostDetail)

        let error = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()

        return Output(posts: postsList, error: error, isLoading: isLoading, selectedPost: selectedPost)
    }

    // MARK: - Private methods

    private func showPostDetail(_ post: Post) {
        onShowDetail?(post)
    }

}
