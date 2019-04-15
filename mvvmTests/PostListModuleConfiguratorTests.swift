//
//  PostListModuleConfiguratorTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 15/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
@testable import mvvm

final class PostListModuleConfiguratorTests: XCTestCase {

    func testDeallocation() {
        assertDeallocation(of: {
            let (view, viewModel) = PostListModuleConfigurator().configure()
            return (view, [viewModel])
        })
    }

}
