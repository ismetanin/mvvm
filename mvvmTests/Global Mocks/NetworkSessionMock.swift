//
//  NetworkSessionMock.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
@testable import mvvm

final class NetworkSessionMock: NetworkSession {

    var invokedData = false
    var invokedDataCount = 0
    var invokedDataParameters: (request: URLRequest, Void)?
    var invokedDataParametersList = [(request: URLRequest, Void)]()
    var stubbedDataResult: Observable<Data> = Observable<Data>.never()

    func data(request: URLRequest) -> Observable<Data> {
        invokedData = true
        invokedDataCount += 1
        invokedDataParameters = (request, ())
        invokedDataParametersList.append((request, ()))
        return stubbedDataResult
    }

}
