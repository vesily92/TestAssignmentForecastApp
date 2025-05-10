//
//  WeatherView.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

final class WeatherView: UIView {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var temperatureLabel: UILabel = makeWeatherInfoLabel(fontSize: 32, weight: .bold)
    private lazy var minTemperatureLabel: UILabel = makeWeatherInfoLabel(textAlignment: .right)
    private lazy var maxTemperatureLabel: UILabel = makeWeatherInfoLabel(textAlignment: .left)
    private lazy var windSpeedLabel: UILabel = makeWeatherInfoLabel()
    private lazy var humidityLabel: UILabel = makeWeatherInfoLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with forecast: Forecast) {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        iconImageView.image = forecast.weatherIcon
        temperatureLabel.text = forecast.currentTemperatureString

        minTemperatureLabel.setAttributedText(
            "Max: " + forecast.minTemperatureString,
            highlighting: [forecast.minTemperatureString],
            with: attributes
        )

        maxTemperatureLabel.setAttributedText(
            "Min: " + forecast.maxTemperatureString,
            highlighting: [forecast.maxTemperatureString],
            with: attributes
        )

        windSpeedLabel.setAttributedText(
            "Wind speed: " + forecast.windSpeedString,
            highlighting: [forecast.windSpeedString],
            with: attributes
        )

        humidityLabel.setAttributedText(
            "Humidity: " + forecast.humidityString,
            highlighting: [forecast.humidityString],
            with: attributes
        )
    }

    private func setupConstraints() {
        let iconStackView = UIStackView(
            arrangedSubviews: [iconImageView, temperatureLabel]
        )
        iconStackView.axis = .vertical

        let minMaxStackView = UIStackView(
            arrangedSubviews: [minTemperatureLabel, maxTemperatureLabel]
        )
        minMaxStackView.distribution = .fillEqually
        minMaxStackView.spacing = 16

        let stackView = UIStackView(arrangedSubviews: [
            iconStackView, minMaxStackView, windSpeedLabel, humidityLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 32

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 140),
        ])
    }

    private func makeWeatherInfoLabel(
        fontSize: CGFloat = 20,
        weight: UIFont.Weight = .regular,
        textAlignment: NSTextAlignment = .center
    ) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.textAlignment = textAlignment

        return label
    }
}
