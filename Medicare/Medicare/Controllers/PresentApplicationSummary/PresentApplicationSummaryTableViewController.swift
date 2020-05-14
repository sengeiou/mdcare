//
//  PresentApplicationSummaryTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class PresentApplicationSummaryTableViewController: PersonalInfoSummaryTableViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var questionCell: QuestionTableViewCell!
    @IBOutlet fileprivate weak var presentApplicationActionCell: ApplyPresentActionTableViewCell!

    // MARK: - Variable

    fileprivate var presenter = PresentApplicationSummaryPresenter()
    fileprivate var router = PresentApplicationSummaryRouter()
    fileprivate var isFirstLoad = false

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isFirstLoad {
            isFirstLoad = true
            tableView.reloadData()
        }
    }

    func set(router: PresentApplicationSummaryRouter) {
        self.router = router
    }

    func set(presentId: Int) {
        presenter.presentId = presentId
    }

    func set(questions: [QuestionModel]) {
        presenter.set(questions: questions)
    }

    override func loadData() {

    }
}

extension PresentApplicationSummaryTableViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        addPresentApplicationActionCellActions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }

    override func configCells() {
        super.configCells()

        _ = questionCell.then {
            $0.titleLabel.text = R.string.localization.questionnaire.localized()
            $0.isUserInteractionEnabled = false
            $0.isVisibleCheckBox = false
            $0.presenter = presenter
        }

        _ = presentApplicationActionCell.then {
            $0.isVisibleTermsView = false
        }

        displayQuestions()
    }

    private func addPresentApplicationActionCellActions() {
        _ = presentApplicationActionCell.termsButton.then {
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

        _ = presentApplicationActionCell.applyButton.then {
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
        questionCell.configCellWithData(data: nil)
    }
}

extension PresentApplicationSummaryTableViewController {

    func didTapTermButton() {
        router.openTerms(
            url: URL(string: "http://app.merry.inc/app/entry_terms/"),
            title: R.string.localization.applicationTerms.localized()
        )
    }

    private func didTapApplyButton() {
        presenter.applicantPresent()
    }
}

// MARK: - UITableViewDelegate

extension PresentApplicationSummaryTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? TSBaseTableViewCell else {
            return UITableView.automaticDimension
        }

        if presenter.isRegisteredUserInfo &&
            userInfoCells.contains(cell) {
            return 0
        } else
            if presenter.isHasNoQuestions &&
            (cell == questionCell) {
            return 0
        }

        return UITableView.automaticDimension
    }
}

// MARK: - PresentApplicationSummaryViewDelegate

extension PresentApplicationSummaryTableViewController: PresentApplicationSummaryViewDelegate {

    func didApplicantPresent(_ message: String?) {
        if message != nil {
            return
        }

        router.openPresentApplicationDone()
    }
}
