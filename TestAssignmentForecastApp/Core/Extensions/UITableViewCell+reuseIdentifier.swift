//
//  UITableViewCell+reuseIdentifier.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
