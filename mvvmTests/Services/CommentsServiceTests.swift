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
        let session = NetworkSessionMock()
        session.stubbedDataResult = Observable<Data>.just(data)
        let service = CommentsService(session: session, store: DataStoreMock())
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
        let session = NetworkSessionMock()
        session.stubbedDataResult = Observable<Data>.just(data)
        let service = CommentsService(session: session, store: DataStoreMock())
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
        let session = NetworkSessionMock()
        let service = CommentsService(session: session, store: DataStoreMock())
        // when
        _ = service.getComments()
        // then
        XCTAssertEqual(session.invokedDataCount, 1)
    }

    func testThatServiceThrowsError() {
        // given
        let error = NSError(domain: "mvvmtestsdomain", code: 2318, userInfo: nil)
        let session = NetworkSessionMock()
        session.stubbedDataResult = Observable<Data>.error(error)
        let store = DataStoreMock()
        let service = CommentsService(session: session, store: store)
        // when
        let result = service.getComments().toBlocking().materialize()
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
                "postId": 1
            },
            {
                "postId": 2,
            }
        ]
        """.data(using: .utf8) ?? Data()
        let session = NetworkSessionMock()
        session.stubbedDataResult = Observable<Data>.just(data)
        let store = DataStoreMock()
        let service = CommentsService(session: session, store: store)
        // when
        _ = service.getComments().toBlocking().materialize()
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
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let session = NetworkSessionMock()
        session.stubbedDataResult = Observable<Data>.error(error)
        let store = DataStoreMock()
        store.stubbedLoadResult = data
        let service = CommentsService(session: session, store: store)
        // when
        let comments = try service.getComments().toBlocking().first()
        // then
        XCTAssertEqual(comments, expectedComments)
        XCTAssert(store.invokedLoad == true)
        XCTAssert(store.invokedLoadCount == 1)
    }

}
