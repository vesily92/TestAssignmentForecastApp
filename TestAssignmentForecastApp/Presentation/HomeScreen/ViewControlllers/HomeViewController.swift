//
//  HomeViewController.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import UIKit

final class HomeViewController: UIViewController {

    var coordinator: Coordinator?
    var onCitySelected: ((Forecast) -> Void)?

    private typealias DataSource = UITableViewDiffableDataSource<Int, Forecast>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Forecast>

    private let viewModel: HomeViewHandler

    private var dataSource: DataSource?
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var loadingView: LoadingView?
    private let refreshControl = UIRefreshControl()

    init(viewModel: HomeViewHandler) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        viewModel.onFetch = { [weak self] in
            self?.applySnapshot()
            self?.hideLoading()
            self?.refreshControl.endRefreshing()
        }

        viewModel.onFailure = { [weak self] in
            self?.applySnapshot()
            self?.hideLoading()
            self?.showNoInternetAlert(refreshControl: self?.refreshControl)
        }

        viewModel.render()
        showLoading()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = 70
        view.addSubview(tableView)
        tableView.register(cell: HomeTableViewCell.self)
        tableView.delegate = self

        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )

        configureDataSource()
    }

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, forecast in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? HomeTableViewCell else {
                return UITableViewCell()
            }

            cell.configure(with: forecast)
            cell.selectionStyle = .none

            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([1])
        snapshot.appendItems(viewModel.forecasts)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func showLoading() {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        loadingView.alpha = 0
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        UIView.animate(withDuration: 0.2) { loadingView.alpha = 1 }

        self.loadingView = loadingView
    }

    private func hideLoading() {
        UIView.animate(withDuration: 0.2) {
            self.loadingView?.alpha = 0
        } completion: { _ in
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }

    @objc private func refreshData() {
        viewModel.refresh()
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCitySelected?(viewModel.forecasts[indexPath.row])
    }
}
