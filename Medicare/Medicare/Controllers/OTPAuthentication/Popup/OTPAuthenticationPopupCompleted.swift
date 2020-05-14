//
//  OTPAuthenticationPopupCompleted.swift
//  Medicare
//
//  Created by Thuan on 4/4/20.
//

import Foundation

final class OTPAuthenticationPopupCompleted: BaseViewController {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var imageSignupView: UIImageView!
    @IBOutlet fileprivate weak var imageSigninView: UIImageView!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var okButton: CommonButton!
    @IBOutlet fileprivate weak var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var containerViewHeightConstraint: NSLayoutConstraint!

    public var message: String?
    public var okButtonTitle: String?
    public var dismissActionCallback: DismissActionCallback?

    class func newInstance() -> OTPAuthenticationPopupCompleted {
        guard let newInstance = R.storyboard.registration.otpAuthenticationPopupCompleted() else {
            fatalError()
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension OTPAuthenticationPopupCompleted {

    override func configView() {
        super.configView()

        view.backgroundColor = ColorName.white.color
        configContainerView()
        configLabels()
        configImageView()
        configOkButton()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        titleLabel.text = title
        messageLabel.text = message
        let okButtonTitle = self.okButtonTitle ?? R.string.localization.buttonOkTitle.localized()
        okButton.setTitle(okButtonTitle, for: .normal)
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = ColorName.white.color
        }

        let padding: CGFloat = 20.0
        containerViewWidthConstraint.constant = screenWidth - 2*padding

        let height: CGFloat = 490.0
        containerViewHeightConstraint.constant = height
    }

    private func configLabels() {
        _ = titleLabel.then {
            $0.font = (message != nil) ? .bold(size: 59.0) : .bold(size: 45)
            $0.textColor = ColorName.cDF4840.color
            $0.textAlignment = .center
        }

        _ = messageLabel.then {
            $0.font = .medium(size: 26.0)
            $0.textColor = ColorName.black.color
            $0.textAlignment = .center
        }
    }

    private func configImageView() {
        _ = imageSignupView.then {
            $0.contentMode = .scaleAspectFit
            $0.image = R.image.signup_success_alert()
            $0.isHidden = !(message != nil)
        }

        _ = imageSigninView.then {
            $0.contentMode = .scaleAspectFit
            $0.image = R.image.signin_success_alert()
            $0.isHidden = (message != nil)
        }
    }

    private func configOkButton() {
        _ = okButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapOkButton()
                })
        }
    }

    private func didTapOkButton() {
        dismiss(animated: true, completion: nil)
        dismissActionCallback?(self)
    }
}
