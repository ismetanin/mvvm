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

    func testThatPostsReturnsCorrect() {
        // given
        let data: [Post] = [
            Post(userId: 1, id: 1, title: "1", body: "1"),
            Post(userId: 2, id: 2, title: "2", body: "2")
        ]
        let service = MockPostsService(responsePolicy: .returnData(data: data))
        let viewModel = PostListViewModel(service: service)

        let list = scheduler.createObserver([Post].self)

        // when
        let ready = scheduler.createColdObservable([.next(10, ())])
            .asDriverOnErrorJustComplete()
        let showPost = Observable<IndexPath>.empty()
            .asDriverOnErrorJustComplete()
        let input = PostListViewModel.Input(ready: ready, showPost: showPost)
        let output = viewModel.transform(input: input)

        // then
        output.list
            .drive(list)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(list.events, [.next(10, data)])
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
