//
//  ChangePersonalInfoSummaryViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class ChangePersonalInfoSummaryViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var containerView: UIView!

    // MARK: - Variable

    fileprivate weak var tableViewController: ChangePersonalInfoSummaryTableViewController!
    fileprivate var router = ChangePersonalInfoSummaryRouter()
    fileprivate var userDetail = UserDetailModel()
    var updateMagazineSubscription = false

    // MARK: - Initialize

    class func newInstance() -> ChangePersonalInfoSummaryViewController {
        guard let newInstance = R.storyboard.myMenu.changePersonalInfoSummaryViewController() else {
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

    func set(router: ChangePersonalInfoSummaryRouter) {
        self.router = router
    }

    func set(userDetail: UserDetailModel) {
        self.userDetail = userDetail
    }

    private func loadData() {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChangePersonalInfoSummaryTableViewController {
            tableViewController = destination
            setupTableViewController()
        }
    }

    private func setupTableViewController() {
        _ = tableViewController.then {
            $0.set(router: router)
            $0.set(userDetail: userDetail)
            $0.updateMagazineSubscription = updateMagazineSubscription
        }
    }
}

extension ChangePersonalInfoSummaryViewController {

    override func configView() {
        super.configView()

        configShadowView()
        configContainerView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.changePersonalInformation.localized()

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

extension ChangePersonalInfoSummaryViewController {

    override func actionBack() {
        router.close()
    }
}
