//
//  CommentsServiceTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import mvvm

final class CommentsServiceTests: XCTestCase {

    // MARK: - Tests

    func testValidDataMapping() throws {
        // given
        let data = """
        [
            {
                "postId": 1
            },
            {
                "postId": 2,
            }
        ]
        """.data(using: .utf8) ?? Data()
        let expectedComments = [
            Comment(postId: 1),
            Comment(postId: 2)
        ]
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = CommentsService(session: session)
        // when
        let comments = try service.getComments().toBlocking().first()
        // then
        XCTAssertEqual(comments, expectedComments)
    }

    func testInvalidDataMapping() {
        // given
        let data = """
        [
            {
                "name": "id labore ex et quam laborum"
            },
            {
                "id": 2
            }
        ]
        """.data(using: .utf8) ?? Data()
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = CommentsService(session: session)
        // when
        let result = service.getComments().toBlocking().materialize()
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
        let service = CommentsService(session: session)
        // when
        _ = service.getComments()
        // then
        XCTAssertEqual(session.invokedDataRequestCount, 1)
    }

}
