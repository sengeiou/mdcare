//
//  NotificationSettingViewController.swift
//  Medicare
//
//  Created by Thuan on 3/4/20.
//

import UIKit

final class NotificationSettingViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbPushNotifi: UILabel!
    @IBOutlet fileprivate weak var switchPushNotifi: UISwitch!

    // MARK: Variables

    var route: NotificationSettingRouter?
    fileprivate var p: NotificationSettingPresenter?

    // MARK: - Initialize

    class func newInstance() -> NotificationSettingViewController {
        guard let newInstance = R.storyboard.setting.notificationSettingViewController() else {
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
}

extension NotificationSettingViewController {

    override func configView() {
        super.configView()

        configLabels()
        addActionSwitchButton()

        p = NotificationSettingPresenter()
        p?.delegate = self
        p?.getUserInfo()
    }

    fileprivate func configLabels() {
        _ = lbPushNotifi.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
            $0.text = R.string.localization.notifiSettingString002.localized()
        }
    }

    fileprivate func addActionSwitchButton() {
        switchPushNotifi.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(R.string.localization.notifiSettingString001.localized())

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension NotificationSettingViewController {

    @objc fileprivate func switchChanged(_ sender: UISwitch) {
        changeStatus(sender.isOn)
    }

    fileprivate func changeStatus(_ isOn: Bool) {
        p?.changeStatus(isOn ? 1: 0)
    }
}

extension NotificationSettingViewController: NotificationSettingPresenterDelegate {

    func getUserInfoCompleted() {
        switchPushNotifi.isOn = ShareManager.shared.currentUser.user_detail.isOpenPush
    }

    func changeStatusCompleted(_ error: String?) {
        if let error = error {
            presentAlertWith(message: error, callback: nil)
            switchPushNotifi.isOn = !switchPushNotifi.isOn
        }
    }
}
