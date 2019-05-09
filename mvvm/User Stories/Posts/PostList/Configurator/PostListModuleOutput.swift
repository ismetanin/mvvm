//
//  PostListModuleOutput.swift
//  mvvm
//
//  Created by Ivan Smetanin on 09/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

protocol PostListModuleOutput: class {
    var onShowDetail: ((Post) -> Void)? { get set }
}
