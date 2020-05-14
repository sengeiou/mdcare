//
//  PresentApplicationTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class PresentApplicationTableViewController: PersonalInfoTableViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var cell10: QuestionTableViewCell!
    @IBOutlet fileprivate weak var cell11: ApplyPresentActionTableViewCell!

    // MARK: - Variable

    fileprivate let presenter = PresentApplicationPresenter()
    fileprivate var router = PresentApplicationRouter()
    fileprivate var isFirstLoad = false

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isFirstLoad {
            isFirstLoad = true
            tableView.reloadData()
        }
    }

    func set(router: PresentApplicationRouter) {
        self.router = router
    }

    func set(presentId: Int) {
        presenter.presentId = presentId
    }

    func set(questions: [QuestionModel]) {
        presenter.questions = questions
    }

    override func loadData() {
        presenter.loadPrefecture()
        presenter.loadTempUserDetail()
    }
}

extension PresentApplicationTableViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        addCell11Actions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    override func configCells() {
        super.configCells()

        _ = cell10.then {
            $0.titleLabel.text = R.string.localization.questionnaire.localized()
            $0.presenter = presenter
        }

        displayQuestions()
    }

    override func configErrorForCells() {
        super.configErrorForCells()

        _ = cell10.then {
            $0.setError(presenter.verifyAnswersMessage())
        }
    }

    private func addCell11Actions() {
        _ = cell11.termsButton.then {
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

        _ = cell11.applyButton.then {
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

    private func displayQuestions() {
        presenter.createCheckBoxGroups()
        cell10.configCellWithData(data: nil)
    }

    override func indexPathForFirstErrorCell() -> IndexPath? {
        var indexPath = super.indexPathForFirstErrorCell()
        guard indexPath == nil else {
            return indexPath
        }

        if presenter.verifyAnswersMessage() != nil {
            indexPath = indexPathForStaticCells[cell10]
        }

        return indexPath
    }
}

extension PresentApplicationTableViewController {

    override func didTapTermButton() {
        router.openTerms(
            url: URL(string: "http://app.merry.inc/app/entry_terms/"),
            title: R.string.localization.applicationTerms.localized()
        )
    }

    private func didTapApplyButton() {
        displayErrorOnInputIfNeed()

        if presenter.verifyUserInfoMessage() != nil {
            return
        } else if presenter.verifyAnswersMessage() != nil {
            return
        }

        openPresentApplicationSummary()
    }

    private func openPresentApplicationSummary() {
        router.openPresentApplicationSummary(
            id: presenter.presentId,
            questions: presenter.questions,
            userDetail: presenter.tempUserDetail
        )
    }
}

// MARK: - UITableViewDelegate

extension PresentApplicationTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? TSBaseTableViewCell else {
            return UITableView.automaticDimension
        }

        if presenter.isRegisteredUserInfo &&
            userInfoCells.contains(cell) {
            return 0
        } else if presenter.isHasNoQuestions &&
            (cell == cell10) {
            return 0
        }

        return UITableView.automaticDimension
    }
}

// MARK: - PresentApplicationViewDelegate

extension PresentApplicationTableViewController: PresentApplicationViewDelegate {

    override func didGetUserInfo() {
        super.didGetUserInfo()
    }
}
