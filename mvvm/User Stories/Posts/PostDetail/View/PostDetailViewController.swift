//
//  PostDetailViewController.swift
//  mvvm
//
//  Created by Ivan Smetanin on 08/05/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout

final class PostDetailViewController: UIViewController {

    // MARK: - Subviews

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var authorNameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var commentsCountLabel = UILabel()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: PostDetailViewModel

    // MARK: - Initialization and deinitialization

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func loadView() {
        super.loadView()
        addSubviews()
    }

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
        let input = PostDetailViewModel.Input(ready: rx.viewDidLoad.asDriver())
        let output = viewModel.transform(input: input)
        output.data
            .drive(onNext: { [weak self] data in
                self?.fill(with: data)
            })
            .disposed(by: disposeBag)

        output.isLoading
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(error: error)
            })
            .disposed(by: disposeBag)
    }

    private func fill(with data: PostDetailViewData) {
        titleLabel.text = data.title
        authorNameLabel.text = data.authorName
        descriptionLabel.text = data.description
        commentsCountLabel.text = L10n.PostDetail.numberOfComments(data.commentsCount)
        view.setNeedsLayout()
    }

    private func configureUI() {
        view.backgroundColor = .white

        titleLabel.textColor = .black
        authorNameLabel.textColor = .black
        descriptionLabel.textColor = .black
        commentsCountLabel.textColor = .black

        titleLabel.numberOfLines = 0
        authorNameLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        commentsCountLabel.numberOfLines = 0

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        commentsCountLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(commentsCountLabel)
        view.addSubview(activityIndicatorView)
    }

    private func layout() {
        scrollView.pin
            .all(view.pin.safeArea)

        contentView.pin
            .horizontally(view.pin.safeArea)
            .all(scrollView.pin.safeArea)
            .sizeToFit(.width)

        titleLabel.pin
            .top(16)
            .start(16)
            .end(16)
            .sizeToFit(.width)

        authorNameLabel.pin
            .below(of: titleLabel, aligned: .start)
            .marginTop(4)
            .start(16)
            .end(16)
            .sizeToFit(.width)

        descriptionLabel.pin
            .below(of: authorNameLabel, aligned: .start)
            .marginTop(8)
            .start(16)
            .end(16)
            .sizeToFit(.width)

        commentsCountLabel.pin
            .below(of: descriptionLabel, aligned: .start)
            .marginTop(8)
            .start(16)
            .end(16)
            .sizeToFit(.width)

        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: commentsCountLabel.frame.maxY + 16
        )

        activityIndicatorView.pin
            .center()
    }

}
