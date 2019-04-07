//
//  PostListTableViewCell.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

final class PostListTableViewCell: UITableViewCell {

    static let identifier = String(describing: PostListTableViewCell.self)

    func configure(with post: Post) {
        textLabel?.text = post.title
        accessoryType = .disclosureIndicator
    }

}
