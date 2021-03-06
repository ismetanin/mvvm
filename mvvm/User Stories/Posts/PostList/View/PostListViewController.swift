//
//  PostListViewController.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PostListViewController: UIViewController {

    // MARK: - Subviews

    private lazy var tableView = UITableView()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)
    private lazy var emptyView = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: PostListViewModel

    // MARK: - Initialization and deinitialization

    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }

    // MARK: - Private methods

    private func bind() {
        let input = PostListViewModel.Input(
            ready: rx.viewDidLoad.asDriver(),
            showPost: tableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input: input)

        output.posts
            .drive(
                tableView.rx.items(
                    cellIdentifier: PostListTableViewCell.identifier,
                    cellType: PostListTableViewCell.self
                )
            ) { _, post, cell in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)

        output.isLoading
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        output.isLoading
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(error: error)
            })
            .disposed(by: disposeBag)

        output.selectedPost
            .drive()
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        title = L10n.PostList.title
        view.backgroundColor = .white
        view.addSubview(emptyView)
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        tableView.register(
            PostListTableViewCell.self,
            forCellReuseIdentifier: PostListTableViewCell.identifier
        )
        tableView.tableFooterView = UIView()
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            self?.tableView.deselectRow(at: index, animated: true)
        }).disposed(by: disposeBag)

        emptyView.text = L10n.PostList.noDataMessage
        emptyView.textColor = .blue
    }

    private func layout() {
        tableView.pin
            .all(view.pin.safeArea)
        emptyView.pin
            .start(16)
            .end(16)
            .vCenter()
            .sizeToFit(.width)
        activityIndicatorView.pin
            .center()
    }

}
