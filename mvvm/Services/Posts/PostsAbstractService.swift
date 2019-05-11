//
//  PostsAbstractService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

protocol PostsAbstractService {
    func getPosts() -> Observable<[Post]>
}
