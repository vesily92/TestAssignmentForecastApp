//
//  LoadingView.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 10.05.2025.
//

import UIKit

final class LoadingView: UIView {

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.style = .large

        return indicator
    }()

    init() {
        super.init(frame: .zero)
        setupConstraints()
    }

    func setupConstraints() {

        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
