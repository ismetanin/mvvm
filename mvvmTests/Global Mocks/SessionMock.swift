//
//  SessionMock.swift
//  mvvmTests
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
@testable import mvvm

final class SessionMock: NetworkSession {

    // MARK: - Nested types

    enum DataRequestResponsePolicy {
        case returnData(Data)
        case noReturn
    }

    // MARK: - Properties

    var dataRequestResponsePolicy: DataRequestResponsePolicy
    var invokedDataRequestCount = 0

    // MARK: - Initialization and deinitialization

    init(dataRequestResponsePolicy: DataRequestResponsePolicy) {
        self.dataRequestResponsePolicy = dataRequestResponsePolicy
    }

    // MARK: - NetworkSession

    func data(request: URLRequest) -> Observable<Data> {
        invokedDataRequestCount += 1
        switch dataRequestResponsePolicy {
        case .returnData(let data):
            return Observable<Data>.just(data)
        case .noReturn:
            return PublishSubject<Data>().asObservable()
        }
    }

}
