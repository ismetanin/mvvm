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

    override func tearDown() {
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
        let data: [Post] = [
            Post(userId: 1, id: 1, title: "1", body: "1"),
            Post(userId: 2, id: 2, title: "2", body: "2")
        ]
        let service = MockPostsService(responsePolicy: .returnData(data: data))
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

        XCTAssertEqual(isLoading.events, [.next(0, false), .next(10, true), .next(10, false)])
    }

    func testThatErrorEmits() {
        // given
        let error: Error = NSError(domain: "", code: 0, userInfo: nil)
        let service = MockPostsService(responsePolicy: .returnError(error: error))
        let viewModel = PostListViewModel(service: service)

        // when
        let ready = PublishSubject<Void>()
        let showPost = Observable<IndexPath>.empty()
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready.asDriverOnErrorJustComplete(), showPost: showPost)
        let output = viewModel.transform(input: input)

        // then
        output.posts
            .drive()
            .disposed(by: disposeBag)
        output.error
            .drive()
            .disposed(by: disposeBag)

        ready.onNext(())
        let gotError = try? output.error.toBlocking().first()

        XCTAssertNotNil(gotError)
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
                return Observable<[Post]>.empty()
            }
        }

    }

}
