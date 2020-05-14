//
//  ChangePersonalInfoTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class ChangePersonalInfoTableViewController: PersonalInfoTableViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var subscribleMagazineCell: SubscribeMagazineTableViewCell!
    @IBOutlet fileprivate weak var cell10: IntroActionTableViewCell!

    // MARK: - Variable

    fileprivate let presenter = ChangePersonalInfoPresenter()
    fileprivate var router = ChangePersonalInfoRouter()

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

    func set(router: ChangePersonalInfoRouter) {
        self.router = router
    }

    override func loadData() {
        super.loadData()

        presenter.loadMagazineIntro()
    }
}

extension ChangePersonalInfoTableViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        addCell10Actions()
        addSubscribleMagazineCellActions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    override func configCells() {
        super.configCells()

        _ = cell10.then {
            $0.agreeButton.setTitle(R.string.localization.change.localized(), for: .normal)
            $0.isVisibleTermsView = false
        }
    }

    private func addCell10Actions() {
        _ = cell10.termsButton.then {
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

        _ = cell10.agreeButton.then {
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

    private func addSubscribleMagazineCellActions() {
        _ = subscribleMagazineCell.termButton.then {
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
    }

    override func didTapAgreeButton() {
        displayErrorOnInputIfNeed()

        if presenter.verifyUserInfoMessage() != nil {
            return
        }

        let updateMagazineSubscription = subscribleMagazineCell.checkBox.on
        openChangePersonalInfoSummary(updateMagazineSubscription: updateMagazineSubscription)
    }

    private func openChangePersonalInfoSummary(updateMagazineSubscription: Bool) {
        router.openChangePersonalInfoSummary(
            userDetail: presenter.tempUserDetail,
            updateMagazineSubscription: updateMagazineSubscription
        )
    }
}

// MARK: - ChangePersonalInfoViewDelegate

extension ChangePersonalInfoTableViewController: ChangePersonalInfoViewDelegate {

    override func didGetUserInfo() {
        super.didGetUserInfo()
        subscribleMagazineCell.setCheckBox(basePresenter.tempUserDetail.magazineSubscribed)
    }

    override func didUpdateUserInfo() {
        router.close(backTo: 2)
    }

    func loadMagazineIntroCompleted(_ url: URL?) {
        subscribleMagazineCell.setIntroImage(url)
    }
}
