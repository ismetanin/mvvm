//
//  UsersAbstractService.swift
//  mvvm
//
//  Created by Ivan Smetanin on 11/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import RxSwift

protocol UsersAbstractService {
    func getUsers() -> Observable<[User]>
}
