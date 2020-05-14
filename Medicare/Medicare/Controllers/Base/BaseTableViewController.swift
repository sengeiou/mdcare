//
//  BaseTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import UIKit

class BaseTableViewController: UITableViewController {

    @IBOutlet open weak var navigationBar: UINavigationBar?

    // MARK: - Variable

    fileprivate var preOffset: CGPoint = .zero
    fileprivate var isDragging: Bool = false

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalizedViews),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        setInteractivePopGestureEnabled()
        configView()
        reloadLocalizedViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setTabBarVisible(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Custom Methods

extension BaseTableViewController {

    @objc func configView() {
        if let navigationBar = self.navigationController?.navigationBar {
            self.navigationBar = navigationBar
        }

        view.backgroundColor = ColorName.white.color
    }
}

// MARK: - Rotation

extension BaseTableViewController {

    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Actions

extension BaseTableViewController {

}

// MARK: - UIScrollViewDelegate

extension BaseTableViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            setTabBarVisible(true)
        }

        guard isDragging else {
            preOffset = scrollView.contentOffset

            return
        }

        guard shouldToogleTabBarByScrolling() else {
            preOffset = scrollView.contentOffset

            return
        }

        let scrollDirection: ScrollDirection
        if preOffset.y > scrollView.contentOffset.y {
            scrollDirection = .down
        } else if preOffset.y < scrollView.contentOffset.y {
            scrollDirection = .up
        } else {
            scrollDirection = .none
        }

        preOffset = scrollView.contentOffset

        switch scrollDirection {
        case .up:
            setTabBarVisible(false)
        case .down:
            setTabBarVisible(true)
        default:
            break
        }
    }
}
