//
//  ViewModel.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
