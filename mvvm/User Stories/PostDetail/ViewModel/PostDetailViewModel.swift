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

    struct Output {
        let data: Driver<PostDetailViewData>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
    }

    // MARK: - Properties

    private let post: Post
    private let usersService: UsersAbstractService
    private let commentsService: CommentsAbstractService

    // MARK: - Initialization and deinitialization

    init(post: Post, usersService: UsersAbstractService, commentsService: CommentsAbstractService) {
        self.post = post
        self.usersService = usersService
        self.commentsService = commentsService
    }

    // MARK: - ViewModel

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let data = input.ready
            .flatMapLatest { _ in
                Observable.zip(
                    self.usersService.getUsers(),
                    self.commentsService.getComments(),
                    resultSelector: { users, comments -> PostDetailViewData in
                        let user = users.first(where: { $0.id == self.post.userId })
                        let commentsCount = comments.filter { $0.postId == self.post.id }.count
                        return PostDetailViewData(
                            title: self.post.title,
                            authorName: user?.name,
                            description: self.post.body,
                            commentsCount: commentsCount
                        )
                    }
                )
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            }

        let error = errorTracker.asDriver()
        let isLoading = activityIndicator.asDriver()

        return Output(data: data, error: error, isLoading: isLoading)
    }

}
