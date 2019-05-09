//
//  PostListViewModelTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 21/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxBlocking
import RxCocoa
import RxSwift
import RxTest
import XCTest
@testable import mvvm

final class PostListViewModelTests: XCTestCase {

    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    // MARK: - XCTestCase

    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    // MARK: - Tests

    func testThatPostsEmitsCorrect() {
        // given
        let data: [Post] = [
            Post(userId: 1, id: 1, title: "1", body: "1"),
            Post(userId: 2, id: 2, title: "2", body: "2")
        ]
        let service = MockPostsService(responsePolicy: .returnData(data: data))
        let viewModel = PostListViewModel(service: service)

        let posts = scheduler.createObserver([Post].self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let showPost = Observable<IndexPath>.empty()
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready, showPost: showPost)
        let output = viewModel.transform(input: input)

        // then
        output.posts
            .drive(posts)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(posts.events, [.next(10, data)])
    }

    func testThatLoadingEmits() {
        // given
        let service = MockPostsService(responsePolicy: .noReturn)
        let viewModel = PostListViewModel(service: service)

        let isLoading = scheduler.createObserver(Bool.self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let showPost = Observable<IndexPath>.empty()
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready, showPost: showPost)
        let output = viewModel.transform(input: input)

        // then
        output.posts
            .drive()
            .disposed(by: disposeBag)
        output.isLoading
            .drive(isLoading)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(isLoading.events, [.next(0, false), .next(10, true)])
    }

    func testThatErrorEmits() {
        // given
        let data: Error = NSError(domain: "mydomain", code: Int.max, userInfo: nil)
        let service = MockPostsService(responsePolicy: .returnError(error: data))
        let viewModel = PostListViewModel(service: service)

        let error = scheduler.createObserver(NSError.self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let showPost = Observable<IndexPath>.empty()
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready, showPost: showPost)
        let output = viewModel.transform(input: input)

        // then
        output.posts
            .drive()
            .disposed(by: disposeBag)
        output.error
            .map { $0 as NSError }
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, data as NSError)])
    }

    func testThatShowPostTriggersPostSelection() {
        // given
        let post = Post(userId: 1, id: 1, title: "1", body: "1")
        let service = MockPostsService(responsePolicy: .returnData(data: [post]))
        let viewModel = PostListViewModel(service: service)

        let showPostObserver = scheduler.createObserver(Post.self)
        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let showPost = scheduler.createColdObservable([.next(10, IndexPath(row: 0, section: 0))])
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready, showPost: showPost)
        let output = viewModel.transform(input: input)
        // then
        output.posts
            .drive()
            .disposed(by: disposeBag)
        output.selectedPost
            .drive(showPostObserver)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertEqual(showPostObserver.events, [.next(10, post)])
    }

    // MARK: - Mocks

    private final class MockPostsService: PostsAbstractService {

        enum ResponsePolicy {
            case returnError(error: Error)
            case returnData(data: [Post])
            case noReturn
        }

        var responsePolicy: ResponsePolicy

        init(responsePolicy: ResponsePolicy) {
            self.responsePolicy = responsePolicy
        }

        func getPosts() -> Observable<[Post]> {
            switch responsePolicy {
            case .returnData(let data):
                return Observable<[Post]>.just(data)
            case .returnError(let error):
                return Observable<[Post]>.error(error)
            case .noReturn:
                return PublishSubject<[Post]>().asObservable()
            }
        }

    }

}
