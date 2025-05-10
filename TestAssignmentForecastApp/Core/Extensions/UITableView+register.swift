//
//  UITableView+register.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
