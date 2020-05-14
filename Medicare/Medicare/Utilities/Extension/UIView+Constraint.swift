//
//  UIView+Constraint.swift
//  Medicare
//
//  Created by sanghv on 7/21/19.
//

import Foundation

extension UIView {

    func addConstraints(withFormat format: String,
                        options: NSLayoutConstraint.FormatOptions = NSLayoutConstraint.FormatOptions(),
                        views: UIView...) {
        var viewDictionary = [String: UIView]()

        for (index, view) in views.enumerated() {

            viewDictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false

        }

        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: options,
            metrics: nil,
            views: viewDictionary
        ))
    }
}
