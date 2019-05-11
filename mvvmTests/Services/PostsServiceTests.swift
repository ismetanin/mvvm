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
        let service = PostsService(session: session)
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
        let service = PostsService(session: session)
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
        let service = PostsService(session: session)
        // when
        _ = service.getPosts()
        // then
        XCTAssertEqual(session.invokedDataRequestCount, 1)
    }

}
