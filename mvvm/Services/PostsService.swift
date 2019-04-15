//
//  PostsService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

final class PostsService: PostsAbstractService {

    func getPosts() -> Observable<[Post]> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            assertionFailure("Can't build url for obtaining posts")
            return Observable.just([])
        }

        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
                .map { data -> [Post] in
                    return try JSONDecoder().decode([Post].self, from: data)
                }
    }

}
