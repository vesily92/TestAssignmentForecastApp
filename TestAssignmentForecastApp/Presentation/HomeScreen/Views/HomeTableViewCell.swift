//
//  HomeTableViewCell.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {

    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let font = UIImage.SymbolConfiguration(textStyle: .title2)
        let weight = UIImage.SymbolConfiguration(weight: .medium)
        let combined = font.applying(weight)
        let image = UIImage(
            systemName: "chevron.right",
            withConfiguration: combined
        )?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(with forecast: Forecast) {
        cityNameLabel.text = forecast.city
        currentTemperatureLabel.text = forecast.currentTemperatureString
        imageView?.image = forecast.weatherIcon
    }

    private func setupConstraints() {
        guard let imageView else { return }

        contentView.addSubview(cityNameLabel)
        contentView.addSubview(currentTemperatureLabel)
        contentView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor),
            cityNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            currentTemperatureLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
            currentTemperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            currentTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.topAnchor.constraint(equalTo: topAnchor),
            chevronImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
