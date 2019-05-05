//
//  NetworkSession.swift
//  mvvm
//
//  Created by Ivan Smetanin on 05/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

protocol NetworkSession {
    func data(request: URLRequest) -> Observable<Data>
}

extension URLSession: NetworkSession {
    func data(request: URLRequest) -> Observable<Data> {
        return rx.data(request: request)
    }
}
