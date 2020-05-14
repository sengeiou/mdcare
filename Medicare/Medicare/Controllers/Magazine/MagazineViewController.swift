//
//  MagazineViewController.swift
//  Medicare
//
//  Created by Thuan on 3/4/20.
//

import UIKit
import Cartography

final class MagazineViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var contentContainerView: UIView!

    // MARK: Variables

    fileprivate var p: MagazinePresenter?
    fileprivate var contentView: ContainerMagazineViewController?

    // MARK: - Initialize

    class func newInstance() -> MagazineViewController {
        guard let newInstance = R.storyboard.magazine.magazineViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name:
            NSNotification.Name(StringConstant.categorySettingChangesNotification),
                                                  object: nil)
    }

    override func logEvent() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadMagazineTab),
                                               name:
            NSNotification.Name(StringConstant.categorySettingChangesNotification),
                                               object: nil)
    }
}

extension MagazineViewController {

    override func configView() {
        super.configView()

        p = MagazinePresenter()
        p?.delegate = self
        loadMagazineTab()
    }

    fileprivate func configContentView(_ categoryList: [MagazineCategoryModel]) {
        if contentView != nil {
            contentView?.view.removeFromSuperview()
            contentView?.removeFromParent()
            contentView = nil
        }

        if categoryList.isEmpty {
            return
        }

        contentView = ContainerMagazineViewController()
        contentView!.categoryList = categoryList
        self.addChild(contentView!)
        contentContainerView.addSubview(contentView!.view)
        contentView!.didMove(toParent: self)

        constrain(contentView!.view) { (view) in
            view.width == view.superview!.width
            view.height == view.superview!.height
            view.left == view.superview!.left
            view.top == view.superview!.top
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(R.string.localization.magazineStringTitle.localized())

        setNavigationBarButton(items: [
            (.home, .left),
            (.myPage, .right)
        ])
    }

    @objc fileprivate func loadMagazineTab() {
        p?.showMagazineTab()
    }
}

extension MagazineViewController: MagazinePresenterDelegate {

    func showMagazineTabCompleted(_ categoryList: [MagazineCategoryModel]) {
        configContentView(categoryList)
    }
}
