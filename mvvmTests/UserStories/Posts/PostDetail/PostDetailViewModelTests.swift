//
//  PostDetailViewModelTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 14/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxBlocking
import RxCocoa
import RxSwift
import RxTest
import XCTest
@testable import mvvm

final class PostDetailViewModelTests: XCTestCase {

    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    // MARK: - XCTestCase

    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    // MARK: - Tests

    func testThatDataBuildsProperly() throws {
        // given
        let commentsService = MockCommentsService()
        commentsService.getCommentsResponsePolicy = .returnData(data: [
            Comment(id: 0, postId: 1), Comment(id: 1, postId: 2), Comment(id: 3, postId: 1)
        ])
        let usersService = MockUsersService()
        usersService.getUsersResponsePolicy = .returnData(data: [
            User(id: 1, name: "John"), User(id: 2, name: "Bob")
        ])
        let post = Post(userId: 1, id: 1, title: "title", body: "body")
        let viewModel = PostDetailViewModel(
            post: post,
            usersService: usersService,
            commentsService: commentsService
        )

        let expectedData = PostDetailViewData(
            title: "title",
            authorName: "John",
            description: "body",
            commentsCount: 2
        )

        // when
        let ready = Observable<Void>.just(()).asDriverOnErrorJustComplete()
        let input = PostDetailViewModel.Input(ready: ready)
        let output = viewModel.transform(input: input)

        // then
        let data = try output.data.toBlocking().first()

        XCTAssert(data?.authorName == expectedData.authorName)
        XCTAssert(data?.title == expectedData.title)
        XCTAssert(data?.description == expectedData.description)
        XCTAssert(data?.commentsCount == expectedData.commentsCount)
    }

    func testThatLoadingEmits() {
        // given
        let commentsService = MockCommentsService()
        let usersService = MockUsersService()
        let post = Post.mocked()
        let viewModel = PostDetailViewModel(
            post: post,
            usersService: usersService,
            commentsService: commentsService
        )

        let isLoading = scheduler.createObserver(Bool.self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let input = PostDetailViewModel.Input(ready: ready)
        let output = viewModel.transform(input: input)

        // then
        output.data
            .drive()
            .disposed(by: disposeBag)

        output.error
            .drive()
            .disposed(by: disposeBag)

        output.isLoading
            .drive(isLoading)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(isLoading.events, [.next(0, false), .next(10, true)])
    }

    func testThatErrorFromCommentsServiceEmits() {
        // given
        let data: Error = NSError(domain: "mydomain", code: Int.max, userInfo: nil)
        let commentsService = MockCommentsService()
        commentsService.getCommentsResponsePolicy = .returnError(error: data)
        let usersService = MockUsersService()
        let post = Post.mocked()
        let viewModel = PostDetailViewModel(
            post: post,
            usersService: usersService,
            commentsService: commentsService
        )

        let error = scheduler.createObserver(NSError.self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let input = PostDetailViewModel.Input(ready: ready)
        let output = viewModel.transform(input: input)

        // then
        output.data
            .drive()
            .disposed(by: disposeBag)

        output.error
            .map { $0 as NSError }
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, data as NSError)])
    }

    func testThatErrorFromUsersServiceEmits() {
        // given
        let data: Error = NSError(domain: "mydomain", code: Int.max, userInfo: nil)
        let commentsService = MockCommentsService()
        let usersService = MockUsersService()
        usersService.getUsersResponsePolicy = .returnError(error: data)
        let post = Post.mocked()
        let viewModel = PostDetailViewModel(
            post: post,
            usersService: usersService,
            commentsService: commentsService
        )

        let error = scheduler.createObserver(NSError.self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let input = PostDetailViewModel.Input(ready: ready)
        let output = viewModel.transform(input: input)

        // then
        output.data
            .drive()
            .disposed(by: disposeBag)

        output.error
            .map { $0 as NSError }
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, data as NSError)])
    }

    // MARK: - Mocks

    private final class MockUsersService: UsersAbstractService {

        enum ResponsePolicy {
            case returnError(error: Error)
            case returnData(data: [User])
            case noReturn
        }

        var getUsersResponsePolicy: ResponsePolicy = .noReturn

        func getUsers() -> Observable<[User]> {
            switch getUsersResponsePolicy {
            case .returnData(let data):
                return Observable<[User]>.just(data)
            case .returnError(let error):
                return Observable<[User]>.error(error)
            case .noReturn:
                return Observable<[User]>.never()
            }
        }

    }

    private final class MockCommentsService: CommentsAbstractService {

        enum ResponsePolicy {
            case returnError(error: Error)
            case returnData(data: [Comment])
            case noReturn
        }

        var getCommentsResponsePolicy: ResponsePolicy = .noReturn

        func getComments() -> Observable<[Comment]> {
            switch getCommentsResponsePolicy {
            case .returnData(let data):
                return Observable<[Comment]>.just(data)
            case .returnError(let error):
                return Observable<[Comment]>.error(error)
            case .noReturn:
                return Observable<[Comment]>.never()
            }
        }

    }

}

private extension Post {

    static func mocked() -> Post {
        return Post(userId: 0, id: 0, title: "", body: "")
    }

}
