//
//  URLCacheDataStore.swift
//  mvvm
//
//  Created by Ivan Smetanin on 12/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

final class URLCacheDataStore: DataStore {

    // MARK: - Nested types

    enum Error: Swift.Error {
        case requestHasNoURL
        case cantBuildURLResponse
    }

    // MARK: - Properties

    private let cache: URLCache

    // MARK: - Initialization and deinitialization

    init(cache: URLCache = URLCache.shared) {
        self.cache = cache
    }

    // MARK: - DataStore

    func save(data: Data, from request: URLRequest) throws {
        guard let url = request.url else {
            throw Error.requestHasNoURL
        }
        guard
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else {
            throw Error.cantBuildURLResponse
        }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: request)
    }

    func load(from request: URLRequest) -> Data? {
        return cache.cachedResponse(for: request)?.data
    }

}
