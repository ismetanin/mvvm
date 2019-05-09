//
//  PostDetailModuleConfiguratorTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 09/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
@testable import mvvm

final class PostDetailModuleConfiguratorTests: XCTestCase {

    func testDeallocation() {
        assertDeallocation(of: {
            let view = PostDetailModuleConfigurator().configure()
            return (view, [])
        })
    }

}
