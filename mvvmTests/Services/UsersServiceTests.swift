//
//  UsersServiceTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import mvvm

final class UsersServiceTests: XCTestCase {

    // MARK: - Tests

    func testValidDataMapping() throws {
        // given
        let data = """
        [
            {
                "id": 1,
                "name": "Leanne Graham"
            },
            {
                "id": 2,
                "name": "Ervin Howell"
            }
        ]
        """.data(using: .utf8) ?? Data()
        let expectedUsers: [User] = [
            User(id: 1, name: "Leanne Graham"),
            User(id: 2, name: "Ervin Howell")
        ]
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = UsersService(session: session, store: DataStoreMock())
        // when
        let users = try service.getUsers().toBlocking().first()
        // then
        XCTAssertEqual(users, expectedUsers)
    }

    func testInvalidDataMapping() {
        // given
        let data = """
        [
            {
                "id": 1
            },
            {
                "name": "Ervin Howell"
            }
        ]
        """.data(using: .utf8) ?? Data()
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let service = UsersService(session: session, store: DataStoreMock())
        // when
        let result = service.getUsers().toBlocking().materialize()
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
        let service = UsersService(session: session, store: DataStoreMock())
        // when
        _ = service.getUsers()
        // then
        XCTAssertEqual(session.invokedDataRequestCount, 1)
    }

    func testThatServiceThrowsError() {
        // given
        let error = NSError(domain: "mvvmtestsdomain", code: 2318, userInfo: nil)
        let session = SessionMock(dataRequestResponsePolicy: .throwError(error))
        let store = DataStoreMock()
        let service = UsersService(session: session, store: store)
        // when
        let result = service.getUsers().toBlocking().materialize()
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
                "id": 1,
                "name": "Leanne Graham"
            },
            {
                "id": 2,
                "name": "Ervin Howell"
            }
        ]
        """.data(using: .utf8) ?? Data()
        let session = SessionMock(dataRequestResponsePolicy: .returnData(data))
        let store = DataStoreMock()
        let service = UsersService(session: session, store: store)
        // when
        _ = service.getUsers().toBlocking().materialize()
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
                "id": 1,
                "name": "Leanne Graham"
            },
            {
                "id": 2,
                "name": "Ervin Howell"
            }
        ]
        """.data(using: .utf8) ?? Data()
        let expectedUsers: [User] = [
            User(id: 1, name: "Leanne Graham"),
            User(id: 2, name: "Ervin Howell")
        ]
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let session = SessionMock(dataRequestResponsePolicy: .throwError(error))
        let store = DataStoreMock()
        store.stubbedLoadResult = data
        let service = UsersService(session: session, store: store)
        // when
        let users = try service.getUsers().toBlocking().first()
        // then
        XCTAssertEqual(users, expectedUsers)
        XCTAssert(store.invokedLoad == true)
        XCTAssert(store.invokedLoadCount == 1)
    }

}
