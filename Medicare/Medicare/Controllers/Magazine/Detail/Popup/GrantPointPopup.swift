//
//  GrantPointPopupViewController.swift
//  Medicare
//
//  Created by Thuan on 4/4/20.
//

import Foundation

final class GrantPointPopup: BaseViewController {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet weak var pointValueLabel: UILabel!
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet fileprivate weak var okButton: CommonButton!
    @IBOutlet fileprivate weak var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonPaddingBottomConstraint: NSLayoutConstraint!

    public var point: String?
    public var size = CGSize(width: screenWidth - 40, height: 490)
    public var needResize = false
    public var dismissActionCallback: DismissActionCallback?

    class func newInstance() -> GrantPointPopup {
        guard let newInstance = R.storyboard.magazine.grantPointPopup() else {
            fatalError()
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension GrantPointPopup {

    override func configView() {
        super.configView()

        view.backgroundColor = ColorName.white.color
        configContainerView()
        configLabels()
        configOkButton()
    }

    private func configContainerView() {
        _ = containerView.then {
            $0.backgroundColor = ColorName.white.color
        }

//        let padding: CGFloat = 20.0
        containerViewWidthConstraint.constant = size.width

//        let height: CGFloat = 490.0
        containerViewHeightConstraint.constant = size.height

        if needResize {
            iconViewWidthConstraint.constant = 150
            buttonPaddingBottomConstraint.constant = 10
        }
    }

    private func configLabels() {
        _ = pointValueLabel.then {
            $0.font = .bold(size: 80)
            $0.textColor = ColorName.cDF4840.color
            $0.text = point
            $0.adjustsFontSizeToFitWidth = true
        }

        _ = pointTitleLabel.then {
            $0.font = .medium(size: 30.0)
            $0.textColor = ColorName.cDF4840.color
            $0.text = R.string.localization.magazineStringPoint.localized()
            $0.adjustsFontSizeToFitWidth = true
        }

        _ = messageLabel.then {
            $0.font = .medium(size: 26.0)
            $0.textColor = ColorName.black.color
            $0.textAlignment = .center
            $0.text = R.string.localization.magazineGrantPointMessage.localized()
        }
    }

    private func configOkButton() {
        _ = okButton.then {
            $0.setTitle(R.string.localization.magazineStringClose.localized(), for: .normal)
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
