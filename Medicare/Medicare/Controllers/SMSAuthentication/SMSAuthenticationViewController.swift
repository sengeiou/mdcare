//
//  SMSAuthenticationViewController.swift
//  Medicare
//
//  Created by Thuan on 3/2/20.
//

import UIKit

final class SMSAuthenticationViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbDescription: UILabel!
    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var tfContent: UITextField!
    @IBOutlet fileprivate weak var lbError: UILabel!
    @IBOutlet fileprivate weak var btnSend: CommonButton!

    // MARK: Variable

    var route: SMSAuthenticationRouter?
    var isRegisterNew = true
    fileprivate var p: SMSAuthenticationPresenter?

    // MARK: - Initialize

    class func newInstance() -> SMSAuthenticationViewController {
        guard let newInstance = R.storyboard.registration.smsAuthenticationViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func actionBack() {
        route?.close()
    }

    @IBAction func sendAction(_ sender: Any) {
        guard let phone = tfContent.text else {
            return
        }

        if phone.isEmpty {
            showError(R.string.localization.smsAuthenNotEmpty.localized())
            return
        }
        showError(nil)

        if isRegisterNew {
            signup(phone)
        } else {
            signin(phone)
        }
    }
}

extension SMSAuthenticationViewController {

    override func configView() {
        super.configView()

        configLabel()
        configTextField()
        configButton()

        p = SMSAuthenticationPresenter()
        p?.delegate = self
    }

    fileprivate func configLabel() {
        _ = lbDescription.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.smsAuthenString003.localized()
        }

        _ = lbTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.smsAuthenString004.localized()
        }

        _ = lbError.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.cCC0D3F.color
            $0.text = ""
        }
    }

    fileprivate func configTextField() {
        _ = tfContent.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16)
            $0.keyboardType = .phonePad
            $0.attributedPlaceholder =
                NSAttributedString(string: "08012345678",
                                   attributes: [NSAttributedString.Key.foregroundColor: ColorName.gray2.color])
            $0.addPaddingLeft(10)
        }
    }

    fileprivate func configButton() {
        _ = btnSend.then {
            $0.setTitle(R.string.localization.smsAuthenString005.localized(), for: .normal)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

//        if isRegisterNew {
//            setTitle(R.string.localization.smsAuthenString001.localized())
//        } else {
//            setTitle(R.string.localization.smsAuthenString002.localized())
//        }
        setTitle(R.string.localization.smsAuthenStringTitle.localized())

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension SMSAuthenticationViewController {

    fileprivate func signin(_ phone: String) {
        let params: [String: Any] = [
            "tel_no": phone
        ]
        p?.signin(params)
    }

    fileprivate func signup(_ phone: String) {
        let params: [String: Any] = [
            "tel_no": phone
        ]
        p?.signup(params)
    }

    fileprivate func showError(_ msg: String?) {
        if msg != nil {
            tfContent.backgroundColor = ColorName.cFFE9F1.color
            lbError.text = msg
        } else {
            tfContent.backgroundColor = ColorName.white.color
            lbError.text = ""
        }
    }
}

extension SMSAuthenticationViewController: SMSAuthenticationPresenterDelegate {

    func signinCompleted(_ request: UserAuthenticationModel?, error: String?) {
        guard let request = request else {
            showError(error)
            return
        }
        request.tel_no = tfContent.text
        route?.openOTPAuthenticationView(isRegisterNew: isRegisterNew, request: request)
    }

    func signupCompleted(_ request: UserAuthenticationModel?, error: String?) {
        guard let request = request else {
            showError(error)
            return
        }
        request.tel_no = tfContent.text
        route?.openOTPAuthenticationView(isRegisterNew: isRegisterNew, request: request)
    }
}
