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
        let service = UsersService(session: session)
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
        let service = UsersService(session: session)
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
        let service = UsersService(session: session)
        // when
        _ = service.getUsers()
        // then
        XCTAssertEqual(session.invokedDataRequestCount, 1)
    }

}
