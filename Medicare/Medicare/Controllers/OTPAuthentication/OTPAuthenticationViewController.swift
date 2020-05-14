//
//  OTPAuthenticationViewController.swift
//  Medicare
//
//  Created by Thuan on 3/23/20.
//

import Foundation

final class OTPAuthenticationViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbDescription: UILabel!
    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var tfContent: UITextField!
    @IBOutlet fileprivate weak var lbError: UILabel!
    @IBOutlet fileprivate weak var btnSend: CommonButton!

    // MARK: Variable

    var route: OTPAuthenticationRouter?
    var isRegisterNew = true
    var request: UserAuthenticationModel?
    fileprivate var p: OTPAuthenticationPresenter?

    // MARK: - Initialize

    class func newInstance() -> OTPAuthenticationViewController {
        guard let newInstance = R.storyboard.registration.otpAuthenticationViewController() else {
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
        guard let otp = tfContent.text else {
            return
        }

        if otp.isEmpty {
            showError(R.string.localization.otpAuthenNotEmpty.localized())
            return
        }
        showError(nil)

        vaidateOTP(otp)
    }
}

extension OTPAuthenticationViewController {

    override func configView() {
        super.configView()

        configLabel()
        configTextField()
        configButton()

        p = OTPAuthenticationPresenter()
        p?.delegate = self
    }

    fileprivate func configLabel() {
        _ = lbDescription.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.otpAuthenStringDesc.localized()
        }

        _ = lbTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.otpAuthenFieldContent.localized()
        }

        _ = lbError.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.cCC0D3F.color
//            $0.text = R.string.localization.otpAuthenError.localized()
        }
    }

    fileprivate func configTextField() {
        _ = tfContent.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16)
            $0.keyboardType = .numberPad
            $0.attributedPlaceholder =
                NSAttributedString(string: R.string.localization.otpAuthenFieldPlaceHolder.localized(),
                                   attributes: [NSAttributedString.Key.foregroundColor: ColorName.gray2.color])
            $0.addPaddingLeft(10)
        }
    }

    fileprivate func configButton() {
        _ = btnSend.then {
            $0.setTitle(R.string.localization.otpAuthenButtonVerify.localized(), for: .normal)
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

//        if isRegisterNew {
//            setTitle(R.string.localization.smsAuthenString001.localized())
//        } else {
//            setTitle(R.string.localization.smsAuthenString002.localized())
//        }
        setTitle(R.string.localization.otpAuthenStringTitle.localized())

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension OTPAuthenticationViewController {

    fileprivate func vaidateOTP(_ otp: String) {
        guard let request = request else {
            return
        }

        let params: [String: Any] = [
            "otp_value": otp,
            "request_id": request.request_id ?? "",
            "tel_no": request.tel_no ?? ""
        ]
        p?.otpValidate(params)
    }

    fileprivate func showPopupCompleted() {
        var title = R.string.localization.completionOfRegistration.localized()
        var button = R.string.localization.buttonBeginTitle.localized()
        var message: String? = R.string.localization.otpAuthenPopupMessage.localized()

        if !isRegisterNew {
            title = R.string.localization.welcomeHome.localized()
            button = R.string.localization.buttonGoHomeTitle.localized()
            message = nil
        }

        showPopup(title: title,
                  message: message,
                               okButtonTitle: button) { [weak self] (_) in
                                guard let weakSelf = self else {
                                    return
                                }

                                if let point = weakSelf.p?.point, point > 0 {
                                    weakSelf.showGrantPointPopup("\(point)")
                                } else {
                                    weakSelf.nextAction()
                                }
        }
    }

    fileprivate func nextAction() {
        if isRegisterNew {
            route?.openMagazineSubscription()
        } else {
            openHome()
        }
    }

    fileprivate func openHome() {
        TabBarController().setAsRootVCAnimated()
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

    fileprivate func showPopup(title: String?,
                               message: String?,
                               okButtonTitle: String?,
                               dismissActionCallback: DismissActionCallback? = nil) {
        let popupCompleted = OTPAuthenticationPopupCompleted.newInstance().then {
            $0.title = title
            $0.message = message
            $0.okButtonTitle = okButtonTitle
            $0.dismissActionCallback = dismissActionCallback
        }

        let formSheetController = MZFormSheetPresentationViewController(
            contentViewController: popupCompleted
        ).then {
            $0.contentViewControllerTransitionStyle = .bounce
            $0.contentViewCornerRadius = 10.0
        }

        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingCompressedSize

        present(formSheetController, animated: true, completion: nil)
    }

    fileprivate func showGrantPointPopup(_ point: String) {
        let grantPointPopup = GrantPointPopup.newInstance().then {
            $0.point = point
            $0.dismissActionCallback = { [weak self] (_) in
                self?.nextAction()
            }
        }

        let formSheetController = MZFormSheetPresentationViewController(
            contentViewController: grantPointPopup
        ).then {
            $0.contentViewControllerTransitionStyle = .bounce
            $0.contentViewCornerRadius = 10.0
        }

        formSheetController.presentationController?.contentViewSize = UIView.layoutFittingCompressedSize

        present(formSheetController, animated: true, completion: nil)
    }
}

extension OTPAuthenticationViewController: OTPAuthenticationPresenterDelegate {

    func otpValidateCompleted(error: String?) {
        if let error = error {
            showError(error)
            return
        }
        updateDeviceTokenToCloud(prefs?.getUserId() ?? 0)
        showPopupCompleted()
    }
}
