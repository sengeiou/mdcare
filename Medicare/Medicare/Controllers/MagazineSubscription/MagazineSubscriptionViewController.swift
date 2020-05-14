//
//  MagazineSubscriptionViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class MagazineSubscriptionViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var containerView: UIView!

    // MARK: - Variable

    fileprivate weak var tableViewController: MagazineSubscriptionTableViewController!
    fileprivate var router = MagazineSubscriptionRouter()

    // MARK: - Initialize

    class func newInstance() -> MagazineSubscriptionViewController {
        guard let newInstance = R.storyboard.magazineSubscription.magazineSubscriptionViewController() else {
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

    func set(router: MagazineSubscriptionRouter) {
        self.router = router
    }

    private func loadData() {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MagazineSubscriptionTableViewController {
            tableViewController = destination
            setupTableViewController()
        }
    }

    private func setupTableViewController() {
        tableViewController.set(router: router)
    }
}

extension MagazineSubscriptionViewController {

    override func configView() {
        super.configView()

        configShadowView()
        configContainerView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.introductionToMagazineSubscription.localized()

        hidesBackButton()
        /*
        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
        */
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

extension MagazineSubscriptionViewController {

    override func actionBack() {
        router.close()
    }
}
