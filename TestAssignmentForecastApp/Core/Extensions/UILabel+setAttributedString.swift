//
//  UILabel+setAttributedString.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import UIKit

extension UILabel {
    func setAttributedText(
        _ fullText: String,
        highlighting substrings: [String],
        with attributes: [NSAttributedString.Key: Any]
    ) {
        let attributed = NSMutableAttributedString(string: fullText)
        let nsString = fullText as NSString

        for substring in substrings {
            var searchRange = NSRange(location: 0, length: nsString.length)
            while true {
                let foundRange = nsString.range(of: substring, options: [], range: searchRange)
                guard foundRange.location != NSNotFound else { break }
                attributed.addAttributes(attributes, range: foundRange)
                let nextLocation = foundRange.location + foundRange.length
                searchRange = NSRange(
                    location: nextLocation,
                    length: nsString.length - nextLocation
                )
            }
        }

        self.attributedText = attributed
    }
}
