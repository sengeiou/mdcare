//
//  MagazineSubscriptionTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class MagazineSubscriptionTableViewController: PersonalInfoTableViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var magazineIntroCell: IntroSubscriptionTableViewCell!
    @IBOutlet fileprivate weak var magazineIntroActionCell: ApplyPresentActionTableViewCell!

    // MARK: - Variable

    fileprivate let presenter = MagazineSubscriptionPresenter()
    fileprivate var router = MagazineSubscriptionRouter()

    override var basePresenter: UserInfoPresenter {
        return presenter
    }

    override var baseRouter: PersonalInfoRouter {
        return router
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func set(router: MagazineSubscriptionRouter) {
        self.router = router
    }

    override func loadData() {
        super.loadData()

        presenter.loadMagazineIntro()
    }
}

extension MagazineSubscriptionTableViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        addMagazineIntroCellActions()
        addMagazineIntroActionCellActions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    override func configCells() {
        super.configCells()

        _ = magazineIntroActionCell.then {
            $0.setTermsButtonTitle(R.string.localization.notesOnSubscription2.localized())
            $0.applyButton.setTitle(R.string.localization.register.localized(), for: .normal)
        }
    }

    private func addMagazineIntroCellActions() {
        _ = magazineIntroCell.registerLaterButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapRegisterLaterButton()
                })
        }
    }

    private func addMagazineIntroActionCellActions() {
        _ = magazineIntroActionCell.termsButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapTermButton()
                })
        }

        _ = magazineIntroActionCell.applyButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapAgreeButton()
                })
        }
    }
}

extension MagazineSubscriptionTableViewController {

    override func didTapAgreeButton() {
        displayErrorOnInputIfNeed()

        if basePresenter.verifyUserInfoMessage() != nil {
            return
        }

        basePresenter.updateUser(forceUpdateMagazineSubscription: true)
    }

    private func didTapRegisterLaterButton() {
        router.openCategorySetting(isRegistration: true, isHiddenBack: false)
    }
}

// MARK: - MagazineSubscriptionViewDelegate

extension MagazineSubscriptionTableViewController: MagazineSubscriptionViewDelegate {

    override func didUpdateUserInfo() {
        router.openCategorySetting(isRegistration: true, isHiddenBack: true)
    }

    func loadMagazineIntroCompleted(_ url: URL?) {
        magazineIntroCell.setIntroImage(url)
    }
}
