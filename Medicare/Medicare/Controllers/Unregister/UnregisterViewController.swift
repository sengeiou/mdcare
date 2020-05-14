//
//  UnregisterViewController.swift
//  Medicare
//
//  Created by Thuan on 4/16/20.
//

import UIKit

class UnregisterViewController: BaseViewController {

    // MARK: Outlets

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var btnUnregister: CommonButton!

    // MARK: Variables

    var router: UnregisterRouter?
    fileprivate var p: UnregisterPresenter?

    // MARK: - Initialize

    class func newInstance() -> UnregisterViewController {
        guard let newInstance = R.storyboard.registration.unregisterViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func actionBack() {
        router?.close()
    }
}

extension UnregisterViewController {

    override func configView() {
        super.configView()

        configLabels()
        configButton()

        p = UnregisterPresenter()
        p?.delegate = self
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 32)
            $0.textColor = ColorName.c333333.color
            $0.setSpacingText(R.string.localization.unregisterStringVerify.localized())
        }

        _ = lbMessage.then {
            $0.font = .regular(size: 14)
            $0.textColor = ColorName.c333333.color
            $0.setSpacingText(R.string.localization.unregisterStringMessage.localized())
        }
    }

    fileprivate func configButton() {
        _ = btnUnregister.then {
            $0.setTitle(R.string.localization.unregisterButtonString.localized(), for: .normal)
            $0.backgroundColor = ColorName.cDF4840.color

            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    self?.showConfirmAlert()
                })
        }
    }

    fileprivate func showConfirmAlert() {
        let alert = UIAlertController.alertWithTitle(title: R.string.localization.unregisterPopupTitle.localized(),
                                         message: R.string.localization.unregisterPopupMessage.localized(),
                                         cancelTitle: R.string.localization.unregisterPopupCancel.localized(),
                                         destructiveTitle: nil,
                                         otherTitles: [R.string.localization.buttonOkTitle.localized()],
                                         callback: { [weak self] (alert) in
                                            if alert.style == .default {
                                                self?.p?.unregister()
                                            }
        })
        present(alert, animated: true, completion: nil)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(R.string.localization.unregisterStringTitle.localized())

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension UnregisterViewController: UnregisterPresenterDelegate {

    func unregisterCompleted() {
        backToFirstView()
    }
}
