//
//  URLCacheDataStoreTests.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 12/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import XCTest
@testable import mvvm

final class URLCacheDataStoreTests: XCTestCase {

    // MARK: - Properties

    private var cache = URLCache(memoryCapacity: 1000, diskCapacity: 1000, diskPath: "URLCacheDataStoreTests")

    override func setUp() {
        super.setUp()
        cache.removeAllCachedResponses()
    }

    func testThatStoreSavesData() {
        // given
        guard let url = URL(string: "https://google.com") else {
            XCTFail()
            return
        }
        let store = URLCacheDataStore(cache: cache)
        let data = Data(repeating: 7, count: 7)
        let request = URLRequest(url: url)
        // when
        do {
            try store.save(data: data, from: request)
            let dataFromStore = store.load(from: request)
            // then
            XCTAssert(data == dataFromStore)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
