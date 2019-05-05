//
//  BaseCoordinatorTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 05/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
@testable import mvvm

final class BaseCoordinatorTests: XCTestCase {

    // MARK: - Properties

    private var baseCoordinator = BaseCoordinator()

    // MARK: - XCTestCase

    override func setUp() {
        baseCoordinator = BaseCoordinator()
    }

    // MARK: - Tests

    func testThatAddAddsChildCoordinators() {
        // given
        let coordinator = MockCoordinator()
        // when
        baseCoordinator.addDependency(coordinator)
        // then
        XCTAssertTrue(baseCoordinator.childCoordinators.count == 1)
    }

    func testThatAddDoesntAddTheSameCoordinatorToChildCoordinators() {
        // given
        let coordinator = MockCoordinator()
        // when
        baseCoordinator.addDependency(coordinator)
        baseCoordinator.addDependency(coordinator)
        // then
        XCTAssertTrue(baseCoordinator.childCoordinators.count == 1)
    }

    func testThatHasDependencyReturnsNilOnNonContainingCoordinator() {
        // given
        let coordinator = MockCoordinator()
        // when
        let resultWhenContainsNone = baseCoordinator.hasDependency(ofType: MockBaseCoordinator.self)
        baseCoordinator.addDependency(coordinator)
        let resultWhenContainsSome = baseCoordinator.hasDependency(ofType: MockBaseCoordinator.self)
        // then
        XCTAssert(resultWhenContainsNone == nil)
        XCTAssert(resultWhenContainsSome == nil)
    }

    func testThatHasDependencyReturnsContainingCoordinator() {
        // given
        let coordinator = MockCoordinator()
        // when
        baseCoordinator.addDependency(coordinator)
        let result = baseCoordinator.hasDependency(ofType: MockCoordinator.self)
        // then
        XCTAssert(result === coordinator)
    }

    func testThatRemoveDependencyRemovesFromChildCoordinators() {
        // given
        let coordinator = MockCoordinator()
        // when
        baseCoordinator.addDependency(coordinator)
        baseCoordinator.removeDependency(coordinator)
        // then
        let hasCoordinator = baseCoordinator.childCoordinators.contains(where: { $0 === coordinator })
        XCTAssertFalse(hasCoordinator)
    }

    func testThatRemoveAllChildsTriggersRemovingAllChildsFromChild() {
        // given
        let coordinator = MockBaseCoordinator()
        // when
        baseCoordinator.addDependency(coordinator)
        baseCoordinator.removeAllChilds()
        // then
        XCTAssertTrue(coordinator.invokedRemoveAllChilds)
    }

    // MARK: - Mocks

    private final class MockCoordinator: Coordinator {
        func start() {}
    }

    private final class MockBaseCoordinator: BaseCoordinator {
        var invokedRemoveAllChilds = false

        override func removeAllChilds() {
            super.removeAllChilds()
            invokedRemoveAllChilds = true
        }
    }

}
