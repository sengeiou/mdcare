//
//  PresentApplicationSummaryViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class PresentApplicationSummaryViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var containerView: UIView!

    // MARK: - Variable

    fileprivate weak var tableViewController: PresentApplicationSummaryTableViewController!
    fileprivate var router = PresentApplicationSummaryRouter()
    fileprivate var presentId: Int = 0
    fileprivate var questions: [QuestionModel] = []
    fileprivate var userDetail = UserDetailModel()

    // MARK: - Initialize

    class func newInstance() -> PresentApplicationSummaryViewController {
        guard let newInstance = R.storyboard.presentApplication.presentApplicationSummaryViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    func set(router: PresentApplicationSummaryRouter) {
        self.router = router
    }

    func set(presentId: Int) {
        self.presentId = presentId
    }

    func set(questions: [QuestionModel]?) {
        self.questions = questions ?? []
    }

    func set(userDetail: UserDetailModel) {
        self.userDetail = userDetail
    }

    private func loadData() {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PresentApplicationSummaryTableViewController {
            tableViewController = destination
            setupTableViewController()
        }
    }

    private func setupTableViewController() {
        _ = tableViewController.then {
            $0.set(router: router)
            $0.set(presentId: presentId)
            $0.set(questions: questions)
            $0.set(userDetail: userDetail)
        }
    }
}

extension PresentApplicationSummaryViewController {

    override func configView() {
        super.configView()

        configShadowView()
        configContainerView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.confirmationOfApplicationContents.localized()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    private func configShadowView() {
        _ = shadowView.then {
            $0.backgroundColor = ColorName.white.color
            // $0.cornerRadius = 10.0
            $0.dropShadowForContainer()
        }
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = ColorName.white.color
            $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }
    }
}

// MARK: - Actions

extension PresentApplicationSummaryViewController {

    override func actionBack() {
        router.close()
    }
}
