//
//  DataStoreMock.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 12/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
@testable import mvvm

final class DataStoreMock: DataStore {

    var invokedSave = false
    var invokedSaveCount = 0
    var invokedSaveParameters: (data: Data, from: URLRequest)?
    var invokedSaveParametersList = [(data: Data, from: URLRequest)]()
    var stubbedSaveError: Error?

    func save(data: Data, from: URLRequest) throws {
        invokedSave = true
        invokedSaveCount += 1
        invokedSaveParameters = (data, from)
        invokedSaveParametersList.append((data, from))
        if let error = stubbedSaveError {
            throw error
        }
    }

    var invokedLoad = false
    var invokedLoadCount = 0
    var invokedLoadParameters: (from: URLRequest, Void)?
    var invokedLoadParametersList = [(from: URLRequest, Void)]()
    var stubbedLoadResult: Data?

    func load(from: URLRequest) -> Data? {
        invokedLoad = true
        invokedLoadCount += 1
        invokedLoadParameters = (from, ())
        invokedLoadParametersList.append((from, ()))
        return stubbedLoadResult
    }

}
