//
//  UIViewController+showNoInternetAlert.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 10.05.2025.
//

import UIKit

extension UIViewController {
    func showNoInternetAlert(refreshControl: UIRefreshControl? = nil) {
        let finishRefreshing = {
            refreshControl?.endRefreshing()
        }

        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your network settings and try again.",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            finishRefreshing()
        }
        alert.addAction(cancel)

        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            finishRefreshing()
            guard let url = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alert.addAction(settings)

        present(alert, animated: true, completion: nil)
    }
}
