//
//  ChangePersonalInfoSummaryTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class ChangePersonalInfoSummaryTableViewController: PersonalInfoSummaryTableViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var subscriptionInfoCell: SubscriptionInfoTableViewCell!
    @IBOutlet fileprivate weak var changePersonalInfoActionCell: ApplyPresentActionTableViewCell!

    // MARK: - Variable

    fileprivate var presenter = ChangePersonalInfoSummaryPresenter()
    fileprivate var router = ChangePersonalInfoSummaryRouter()

    override var basePresenter: UserInfoPresenter {
        return presenter
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func set(router: ChangePersonalInfoSummaryRouter) {
        self.router = router
    }

    override func loadData() {

    }
}

extension ChangePersonalInfoSummaryTableViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        addChangePersonalInfoActionCellActions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    override func configCells() {
        super.configCells()

        _ = changePersonalInfoActionCell.then {
            $0.applyButton.setTitle(R.string.localization.change.localized(), for: .normal)
            $0.isVisibleTermsView = false
        }

        _ = subscriptionInfoCell.then {
            $0.setSubscriptionValue(isRegistration: !basePresenter.tempUserDetail.magazineSubscribed)
        }
    }

    private func addChangePersonalInfoActionCellActions() {
        _ = changePersonalInfoActionCell.termsButton.then {
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

        _ = changePersonalInfoActionCell.applyButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapApplyButton()
                })
        }
    }
}

extension ChangePersonalInfoSummaryTableViewController {

    private func didTapTermButton() {
        router.openTerms(
            url: URL(string: "about:blank"),
            title: R.string.localization.notesOnSubscription2.localized()
        )
    }

    private func didTapApplyButton() {
        presenter.updateUser(updateMagazineSubscription: updateMagazineSubscription)
    }
}

extension ChangePersonalInfoSummaryTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell == subscriptionInfoCell && !updateMagazineSubscription {
            return 0.1
        }
        return UITableView.automaticDimension
    }
}

// MARK: - ChangePersonalInfoSummaryViewDelegate

extension ChangePersonalInfoSummaryTableViewController: ChangePersonalInfoSummaryViewDelegate {

    override func didUpdateUserInfo() {
        router.openChangePersonalInfoDone()
    }
}
