//
//  PostsService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

final class PostsService: PostsAbstractService {

    // MARK: - Nested types

    private enum Constants {
        static let postsURL = URL(string: "posts", relativeTo: URLs.base)
    }

    // MARK: - Properties

    private let session: NetworkSession

    // MARK: - Initialization and deinitialization

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - PostsAbstractService

    func getPosts() -> Observable<[Post]> {
        guard let url = Constants.postsURL else {
            assertionFailure("Can't build url for obtaining posts")
            return Observable.just([])
        }

        let request = URLRequest(url: url)
        return session
            .data(request: request)
            .decode(to: [Post].self)
    }

}
