//
//  UsersService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

final class UsersService: UsersAbstractService {

    // MARK: - Nested types

    private enum Constants {
        static let usersURL = URL(string: "users", relativeTo: URLs.base)
    }

    // MARK: - Properties

    private let session: NetworkSession
    private let store: DataStore

    // MARK: - Initialization and deinitialization

    init(session: NetworkSession = URLSession.shared, store: DataStore = URLCacheDataStore()) {
        self.session = session
        self.store = store
    }

    // MARK: - PostsAbstractService

    func getUsers() -> Observable<[User]> {
        guard let url = Constants.usersURL else {
            assertionFailure("Can't build url for obtaining users")
            return Observable.just([])
        }

        let request = URLRequest(url: url)
        return session
            .data(request: request)
            .process(for: request, decodeTo: [User].self, store: store)
    }

}
