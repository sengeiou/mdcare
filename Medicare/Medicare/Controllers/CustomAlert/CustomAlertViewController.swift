//
//  CustomAlertViewController.swift
//  Medicare
//
//  Created by sanghv on 8/5/19.
//

import UIKit

public typealias DismissActionCallback = (UIViewController) -> Void

final class CustomAlertViewController: BaseViewController {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var subMessageLabel: UILabel!
    @IBOutlet fileprivate weak var okButton: CommonButton!
    @IBOutlet fileprivate weak var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var containerViewHeightConstraint: NSLayoutConstraint!

    public var message: String?
    public var subMessage: String?
    public var image: UIImage?
    public var okButtonTitle: String?
    public var dismissActionCallback: DismissActionCallback?

    class func newInstance() -> CustomAlertViewController {
        guard let newInstance = R.storyboard.customAlert.instantiateInitialViewController() else {
            fatalError()
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension CustomAlertViewController {

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

        let messageIsEmpty = message?.isEmpty ?? true
        let subMessageIsEmpty = subMessage?.isEmpty ?? true
        messageLabel.isHidden = messageIsEmpty
        subMessageLabel.isHidden = subMessageIsEmpty
        messageLabel.attributedText = message?.attributeString(configs: lineHeightConfig(1.0))
        subMessageLabel.attributedText = subMessage?.attributeString(configs: lineHeightConfig(1.0))
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
        _ = messageLabel.then {
            $0.font = .bold(size: 38)
            $0.textColor = ColorName.cDF4840.color
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.numberOfLines = 0
        }

        _ = subMessageLabel.then {
            $0.font = .bold(size: 25.0)
            $0.textColor = ColorName.black.color
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.numberOfLines = 0
        }
    }

    private func configImageView() {
        _ = imageView.then {
            $0.contentMode = .scaleAspectFit
            $0.image = image ?? R.image.successAlert()
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
