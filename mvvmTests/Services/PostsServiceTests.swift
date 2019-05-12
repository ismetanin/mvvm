//
//  PostsServiceTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 05/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import mvvm

final class PostsServiceTests: XCTestCase {

    // MARK: - Tests

    func testValidDataMapping() throws {
        // given
        let data = """
        [
          {
            "userId": 1,
            "id": 1,
            "title": "sunt aut",
            "body": "quia et"
          },
          {
            "userId": 1,
            "id": 2,
            "title": "qui est",
            "body": "est rerum"
          }
        ]
        """.data(using: .utf8) ?? Data()
        let expectedPosts = [
            Post(userId: 1, id: 1, title: "sunt aut", body: "quia et"),
            Post(userId: 1, id: 2, title: "qui est", body: "est rerum")
        ]
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = PostsService(session: session, store: DataStoreMock())
        // when
        let posts = try service.getPosts().toBlocking().first()
        // then
        XCTAssertEqual(posts, expectedPosts)
    }

    func testInvalidDataMapping() {
        // given
        let data = """
        [
          {
            "userId": 1
          },
          {
            "body": "est rerum"
          }
        ]
        """.data(using: .utf8) ?? Data()
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = PostsService(session: session, store: DataStoreMock())
        // when
        let result = service.getPosts().toBlocking().materialize()
        // then
        switch result {
        case .completed:
            XCTFail("Expected result to complete with error, but result was successful.")
        case .failed:
            XCTAssert(true)
        }
    }

    func testThatServiceCallTriggersOnlyOneSessionCall() {
        // given
        let session = SessionMock(dataRequestResponsePolicy: .noReturn)
        let service = PostsService(session: session, store: DataStoreMock())
        // when
        _ = service.getPosts()
        // then
        XCTAssertEqual(session.invokedDataRequestCount, 1)
    }

    func testThatServiceThrowsError() {
        // given
        let error = NSError(domain: "mvvmtestsdomain", code: 2318, userInfo: nil)
        let session = SessionMock(dataRequestResponsePolicy: .throwError(error))
        let store = DataStoreMock()
        let service = PostsService(session: session, store: store)
        // when
        let result = service.getPosts().toBlocking().materialize()
        // then
        switch result {
        case .completed:
            XCTFail("Expected result to complete with error, but result was successful.")
        case .failed(_, let resultError):
            XCTAssert(error == resultError as NSError)
        }
    }

    func testThatServiceStoresDataInStore() throws {
        // given
        let data = """
        [
          {
            "userId": 1,
            "id": 1,
            "title": "sunt aut",
            "body": "quia et"
          },
          {
            "userId": 1,
            "id": 2,
            "title": "qui est",
            "body": "est rerum"
          }
        ]
        """.data(using: .utf8) ?? Data()
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let store = DataStoreMock()
        let service = PostsService(session: session, store: store)
        // when
        _ = service.getPosts().toBlocking().materialize()
        // then
        XCTAssert(store.invokedSave)
        XCTAssert(store.invokedSaveCount == 1)
        XCTAssert(store.invokedSaveParameters?.0 == data)
    }

    func testThatServiceUsesDataFromStoreInCaseSessionError() throws {
        // given
        let data = """
        [
          {
            "userId": 1,
            "id": 1,
            "title": "sunt aut",
            "body": "quia et"
          },
          {
            "userId": 1,
            "id": 2,
            "title": "qui est",
            "body": "est rerum"
          }
        ]
        """.data(using: .utf8) ?? Data()
        let expectedPosts = [
            Post(userId: 1, id: 1, title: "sunt aut", body: "quia et"),
            Post(userId: 1, id: 2, title: "qui est", body: "est rerum")
        ]
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let session = SessionMock(dataRequestResponsePolicy: .throwError(error))
        let store = DataStoreMock()
        store.stubbedLoadResult = data
        let service = PostsService(session: session, store: store)
        // when
        let posts = try service.getPosts().toBlocking().first()
        // then
        XCTAssertEqual(posts, expectedPosts)
        XCTAssert(store.invokedLoad == true)
        XCTAssert(store.invokedLoadCount == 1)
    }

}
