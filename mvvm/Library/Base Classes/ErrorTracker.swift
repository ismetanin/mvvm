//
//  ErrorTracker.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy

    // MARK: - Properties

    private let _subject = PublishSubject<Error>()

    // MARK: - Initialization and deinitialization

    deinit {
        _subject.onCompleted()
    }

    // MARK: - Internal methods

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable()
            .do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable()
            .asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    // MARK: - Private methods

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

}

// MARK: - Extensions

extension ObservableConvertibleType {

    func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }

}
