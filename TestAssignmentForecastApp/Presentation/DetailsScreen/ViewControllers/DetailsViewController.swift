//
//  DetailsViewController.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

final class DetailsViewController: UIViewController {

    private let viewModel: DetailsViewHandler

    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()

    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: DetailsViewHandler) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        weatherView.configure(with: viewModel.forecast)

        viewModel.onFetch = { [weak self] in
            self?.refreshControl.endRefreshing()
        }

        viewModel.onFailure = { [weak self] in
            self?.showNoInternetAlert(refreshControl: self?.refreshControl)
        }

    }

    private func setupSubviews() {
        scrollView.frame = view.bounds
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        scrollView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        scrollView.addSubview(weatherView)

        NSLayoutConstraint.activate([
            weatherView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            weatherView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    @objc private func handleRefresh() {
        viewModel.refresh()
    }
}
