//
//  PasswordGenerationViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class PasswordGenerationViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var guideLabel: UILabel!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var copyButton: UIButton!
    @IBOutlet fileprivate weak var backToMenuButton: CommonButton!

    // MARK: - Variable

    fileprivate let presenter = PasswordGenerationPresenter()
    fileprivate var router = PasswordGenerationRouter()

    // MARK: - Initialize

    class func newInstance() -> PasswordGenerationViewController {
        guard let newInstance = R.storyboard.myMenu.passwordGenerationViewController() else {
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

    func set(router: PasswordGenerationRouter) {
        self.router = router
    }

    private func loadData() {

    }
}

extension PasswordGenerationViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configShadowView()
        configGuideLabel()
        configTextField()
        configButtons()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.passwordGeneration.localized()
        let guideAttr = lineHeightConfig(1.5, alignment: .left)
        guideLabel.attributedText = R.string.localization.pleaseCopyOrWriteDownYourPassword.localized()
            .attributeString(configs: guideAttr)
        copyButton.setTitle(R.string.localization.makeACopy.localized(), for: .normal)
        backToMenuButton.setTitle(R.string.localization.backToMyPage.localized(), for: .normal)

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

    private func configGuideLabel() {
        _ = guideLabel.then {
            $0.font = .medium(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 0
        }
    }

    private func configTextField() {
        _ = textField.then {
            $0.font = .regular(size: 16.0)
            $0.textColor = ColorName.c333333.color
        }
    }

    private func configButtons() {
        _ = copyButton.then {
            $0.backgroundColor = ColorName.cED9E9E.color
            $0.setImage(R.image.copy()?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setTitleColor(ColorName.white.color, for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 8.0)
            $0.titleLabel?.font = .medium(size: 14.0)

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapCopyPassword()
                })
        }

        _ = backToMenuButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapReturnToMenu()
                })
        }
    }
}

// MARK: - Actions

extension PasswordGenerationViewController {

    private func didTapCopyPassword() {
        UIPasteboard.general.string = textField.text
    }

    private func didTapReturnToMenu() {
        router.close(backTo: 2)
    }

    override func actionBack() {
        router.close()
    }
}

// MARK: - PasswordGenerationViewDelegate

extension PasswordGenerationViewController: PasswordGenerationViewDelegate {

}
