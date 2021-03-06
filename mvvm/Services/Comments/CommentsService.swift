//
//  CommentsService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

final class CommentsService: CommentsAbstractService {

    // MARK: - Nested types

    private enum Constants {
        static let commentsURL = URL(string: "comments", relativeTo: URLs.base)
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

    func getComments() -> Observable<[Comment]> {
        guard let url = Constants.commentsURL else {
            assertionFailure("Can't build url for obtaining users")
            return Observable.just([])
        }

        let request = URLRequest(url: url)
        return session
            .data(request: request)
            .process(for: request, decodeTo: [Comment].self, store: store)
    }

}
