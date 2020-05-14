//
//  RecoverAccountViewController.swift
//  Medicare
//
//  Created by Thuan on 3/4/20.
//

import UIKit

final class RecoverAccountViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var tfPassword: UITextField!
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet fileprivate weak var btnRecover: CommonButton!

    // MARK: Variable

    var route: RecoverAccountRouter?

    // MARK: - Initialize

    class func newInstance() -> RecoverAccountViewController {
        guard let newInstance = R.storyboard.registration.recoverAccountViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recoverAction(_ sender: Any) {
        presentCustomAlertWith(title: R.string.localization.recoverAccountPopupCompleted001.localized(),
                               image: nil,
                               message: R.string.localization.recoverAccountPopupCompleted002.localized(),
                               okButtonTitle: R.string.localization.buttonGoHomeTitle.localized()) { _ in

                                TabBarController().setAsRootVCAnimated()
        }
    }

    override func actionBack() {
        route?.close()
    }
}

extension RecoverAccountViewController {

    override func configView() {
        super.configView()

        configLabels()
        configTextFields()
        configButtons()
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.text = R.string.localization.recoverAccountString002.localized()
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbError.then {
            $0.isHidden = true
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.cCC0D3F.color
            $0.text = R.string.localization.recoverAccountString004.localized()
        }
    }

    fileprivate func configTextFields() {
        _ = tfPassword.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.isSecureTextEntry = true
            $0.addPaddingLeft(10)
        }
    }

    fileprivate func configButtons() {
        _ = btnRecover.then {
            $0.setTitle(R.string.localization.recoverAccountString003.localized(), for: .normal)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(R.string.localization.recoverAccountString001.localized())

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

}
