//
//  StartupViewController.swift
//  Medicare
//
//  Created by sanghv on 6/27/19.
//

import UIKit

final class StartupViewController: BaseViewController {

    // MARK: - Variables

    fileprivate let router = StartupRouter()

    // MARK: - Initialize

    class func newInstance() -> StartupViewController {
        guard let newInstance = R.storyboard.startup.startupViewController() else {
            fatalError()
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showLoading()
    }
}

extension StartupViewController {

    override func configView() {
        super.configView()

        router.viewController = self
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }
}

extension StartupViewController {

    private func showLoading() {
        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            popHUDActivity()

            guard let weakSelf = self else {
                return
            }

            weakSelf.startDiscoveryApplication()
        }
    }

    private func startDiscoveryApplication() {
//        let tabBarVC = R.storyboard.main.instantiateInitialViewController()
//        tabBarVC?.setAsRootVCAnimated()

#warning("For demo")
        demo11()
    }

    private func demo1() {
        presentCustomAlertWith(
            title: nil,
            image: R.image.failIconAlert(),
            message: R.string.localization.notEnoughPoints.localized(),
            okButtonTitle: R.string.localization.close.localized())
    }

    private func demo2() {
        router.openCategorySetting(isRegistration: false, isHiddenBack: false)
    }

    private func demo3() {
        router.openMagazineSubscription()
    }

    private func demo4() {
        router.openPointBalance()
    }

    private func demo5() {
        router.openMyMenu()
    }

    private func demo6() {
        router.openDataTransfer()
    }

    private func demo7() {
        router.openPasswordGeneration()
    }

    private func demo8() {
        router.openTerms(
            url: URL(string: "about:blank"),
            title: "Demo"
        )
    }

    private func demo9() {
        router.openPresentApplication(id: 1)
    }

    private func demo10() {
        router.openWellness()
    }

    private func demo11() {
        TabBarController().setAsRootVCAnimated()
    }

    private func demo12() {
        router.openPresentApplicationDone()
    }
}
