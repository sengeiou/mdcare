//
//  FirstViewController.swift
//  Medicare
//
//  Created by Thuan on 3/2/20.
//

import UIKit
import AttributedTextView

final class FirstViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var tvTermAndPolicy: AttributedTextView!
    @IBOutlet fileprivate weak var lbRegisterNew: UILabel!
    @IBOutlet fileprivate weak var lbHaveAccount: UILabel!
    @IBOutlet fileprivate weak var btnRegisterNew: CommonButton!
    @IBOutlet fileprivate weak var btnHaveAccount: CommonButton!
    @IBOutlet weak var lbNotice: UILabel!

    // MARK: Variables

    fileprivate let route = FirstViewRouter()

    // MARK: - Initialize

    class func newInstance() -> FirstViewController {
        guard let newInstance = R.storyboard.registration.firstViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func registerNewAction(_ sender: Any) {
        route.openAuthenticationView(isRegisterNew: true)
    }

    @IBAction func haveAccountAction(_ sender: Any) {
        route.openAuthenticationView(isRegisterNew: false)
    }

    @IBAction func recoverAccountAction(_ sender: Any) {
        route.openRecoverView()
    }
}

extension FirstViewController {

    override func configView() {
        super.configView()

        route.viewController = self

        configLabels()
        configButtons()
        configTextView()
    }

    fileprivate func configLabels() {
        _ = lbRegisterNew.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.firstStringRegisterNew.localized()
        }

        _ = lbHaveAccount.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.firstString006.localized()
        }

        _ = lbNotice.then {
            $0.font = .regular(size: 14)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.firstString007.localized()
        }
    }

    fileprivate func configButtons() {
        _ = btnRegisterNew.then {
            $0.setTitle(R.string.localization.firstString005.localized(), for: .normal)
        }

        _ = btnHaveAccount.then {
            $0.setTitle(R.string.localization.firstButtonLogin.localized(), for: .normal)
            $0.backgroundColor = ColorName.cA5BE51.color
        }
    }

    fileprivate func configTextView() {
        _ = tvTermAndPolicy.then {
            $0.attributer = (R.string.localization.firstString002.localized())
                .font(.medium(size: 14))
                .underline
                .makeInteract({ [weak self] _ in
                    self?.openTerm()
                })
            .append("・").color(ColorName.c333333.color)
            .append(R.string.localization.firstString003.localized())
                .font(.medium(size: 14))
                .underline
                .makeInteract({ [weak self] _ in
                    self?.openPolicy()
                })
            .append(" \(R.string.localization.firstString004.localized())")
                .font(.regular(size: 14))
                .color(ColorName.c333333.color)
                .setLinkColor(ColorName.c0092C4.color)
            $0.textAlignment = .center
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }
}

extension FirstViewController {

    fileprivate func openTerm() {
        route.openTerms(
            url: URL(string: "http://app.merry.inc/app/terms/"),
            title: R.string.localization.firstString002.localized()
        )
    }

    fileprivate func openPolicy() {
        route.openTerms(
            url: URL(string: "http://app.merry.inc/app/privacy/"),
            title: R.string.localization.firstString003.localized()
        )
    }
}
