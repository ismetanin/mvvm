//
//  ActivityIndicator.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {

    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    // MARK: - Properties

    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    // MARK: - Initialization and deinitialization

    public init() {
        _loading = _relay.asDriver()
            .distinctUntilChanged()
    }

    // MARK: - Private methods

    private func subscribed() {
        _lock.lock()
        _relay.accept(true)
        _lock.unlock()
    }

    private func sendStopLoading() {
        _lock.lock()
        _relay.accept(false)
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }

    // MARK: - Fileprivate methods

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }

}

// MARK: - ObservableConvertibleType extension

extension ObservableConvertibleType {

    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }

}
