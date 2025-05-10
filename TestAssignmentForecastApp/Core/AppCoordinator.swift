//
//  AppCoordinator.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerType
    private let coreDataManager: CoreDataManagerType

    init(
        navigationController: UINavigationController,
        networkManager: NetworkManagerType,
        coreDataManager: CoreDataManagerType
    ) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }

    func start() {
        setHomeViewController()
    }

    private func setHomeViewController() {
        let viewModel = HomeViewModel(
            networkManager: networkManager,
            coreDataManager: coreDataManager
        )

        let viewController = HomeViewController(viewModel: viewModel)
        viewController.coordinator = self

        viewController.onCitySelected = { [weak self] forecast in
            self?.pushDetailsViewController(with: forecast)
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func pushDetailsViewController(with forecast: Forecast) {
        let viewModel = DetailsViewModel(
            forecast: forecast,
            networkManager: networkManager,
            coreDataManager: coreDataManager
        )

        let viewController = DetailsViewController(viewModel: viewModel)
        viewController.title = forecast.city
        navigationController.pushViewController(viewController, animated: true)
    }
}
