//
//  Observable+Ext.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {

    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }

}

extension SharedSequenceConvertibleType {

    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

}

extension ObservableType where E == Data {

    /// Maps given data to provided Model type using the JSONDecoder.
    ///
    /// - Parameters:
    ///   - to: Model to which Data should be decoded.
    ///   - decoder: Decoder that will be used for decoding.
    /// - Returns: Observable with provided Model.
    func decode<Model: Decodable>(
        to: Model.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<Model> {
        return map { data -> Model in
            return try decoder.decode(Model.self, from: data)
        }
    }

}

extension Observable where E == Data {

    /// Store data from the Observable in provided store for the request.
    ///
    /// - Parameters:
    ///   - request: Request for which data should be saved.
    ///   - store: Store that should be used for storing.
    /// - Returns: The source sequence with the store behavior applied.
    func store(for request: URLRequest, in store: DataStore) -> Observable<E> {
        return self.do(onNext: { data in
            try store.save(data: data, from: request)
        })
    }

    /// Decodes the data and stores in cache. In case of error catch tries to load from store.
    ///
    /// - Parameters:
    ///   - request: Request for which data should be processed.
    ///   - decodeTo: Model to which Data should be decoded.
    ///   - store: Store that should be used for storing and loading.
    /// - Returns: Observable with provided Model.
    func process<Model>(
        for request: URLRequest,
        decodeTo: Model.Type,
        store: DataStore
    ) -> Observable<Model> where Model: Decodable {
        return self
            .catchError { error -> Observable<Data> in
                if let data = store.load(from: request) {
                    return Observable<Data>.just(data)
                } else {
                    return Observable<Data>.error(error)
                }
            }
            .store(for: request, in: store)
            .decode(to: Model.self)
    }

}
