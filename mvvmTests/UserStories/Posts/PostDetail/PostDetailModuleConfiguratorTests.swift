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
            let post = Post(userId: 0, id: 0, title: "", body: "")
            let (view, output) = PostDetailModuleConfigurator().configure(with: post)
            return (view, [output])
        })
    }

}
