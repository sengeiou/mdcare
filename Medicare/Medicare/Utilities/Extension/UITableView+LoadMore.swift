//
//  UITableView+Extension.swift
//  Medicare
//
//  Created by Thuan on 4/21/20.
//

import Foundation

extension UITableView {

    var indicatorView: UIActivityIndicatorView? {
        if self.tableFooterView == nil {
            var activityIndicatorView = UIActivityIndicatorView()
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 20)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        } else {
            if let footer = self.tableFooterView as? UIActivityIndicatorView {
                return footer
            }
            return nil
        }
    }

    func addLoading(_ indexPath: IndexPath, callback: @escaping (() -> Void)) {
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                indicatorView?.startAnimating()
                indicatorView?.isHidden = false
                callback()
            }
        }
    }

    func stopLoading() {
        indicatorView?.stopAnimating()
        indicatorView?.isHidden = true
        self.tableFooterView = nil
    }
}
