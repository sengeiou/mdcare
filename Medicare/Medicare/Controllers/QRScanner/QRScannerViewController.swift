//
//  QRScannerViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class QRScannerViewController: BaseViewController {

    @IBOutlet fileprivate weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }

    // MARK: - Variable

    fileprivate let presenter = QRScannerPresenter()
    fileprivate var router = QRScannerRouter()

    // MARK: - Initialize

    class func newInstance() -> QRScannerViewController {
        guard let newInstance = R.storyboard.point.qrScannerViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setTabBarVisible(false, animated: false)

        startScanning()

        /*
        qrScanningSucceededWithCode(
            // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InR5cGUiOjEsInRhcmdldF9pZCI6M319.iwRcSKFb7tQxt9fX1BF7i6El6QmH_lbsn-KZitCc-Ps"
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InR5cGUiOjEsInRhcmdldF9pZCI6NH19.DcBdtatrXoUIGTupp5ns4UoBQ6BtvPTKrh0YFndPd0s"
            // "eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InRhcmdldF9pZCI6MSwidHlwZSI6MX19.tO6TvbdzJhHXZUIpEH0wfTmr55E61iZ2YlJNiDbbJBg"
            // "eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InRhcmdldF9pZCI6MiwidHlwZSI6Mn19.XS2JvUtwzSrhyxbylR-ZqLs23eAopXTwZzsGch2CrTA"
            // "eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7InRhcmdldF9pZCI6MiwidHlwZSI6MX19.dsKFSIorKFzbPlGEcnYVvJ2IZlYKRHSE2t37RoRdGk4"
        )
        */
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }

        super.viewWillDisappear(animated)
    }

    func set(router: QRScannerRouter) {
        self.router = router
    }
}

extension QRScannerViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = "QR Scanner"

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }
}

extension QRScannerViewController {

    override func actionBack() {
        router.close()
    }

    private func startScanning() {
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
}

extension QRScannerViewController {

    private func showGrantPointPopup(_ point: String) {
        let grantPointPopup = GrantPointPopup.newInstance().then {
            $0.point = point
            $0.dismissActionCallback = { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }

                weakSelf.actionBack()
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

    private func openPresentApplication(gift: GiftModel) {
        let giftId = gift.id
        let giftTitle = gift.title
        let questions = gift.present_question
        router.openPresentApplication(
            id: giftId,
            presentTitle: giftTitle,
            questions: questions
        )
    }

    private func presentAlreadyApplicantWarning() {
        presentCustomAlertWith(
            title: nil,
            image: R.image.failIconAlert(),
            message: "このプレゼントは\n応募済みです。", // R.string.localization.applicantFailed.localized(),
            okButtonTitle: R.string.localization.close.localized(),
            dismissActionCallback: { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }

                weakSelf.actionBack()
        })
    }

    private func displayPointNotEnoughWarning() {
        presentCustomAlertWith(
            title: nil,
            image: R.image.failIconAlert(),
            message: R.string.localization.notEnoughPoints.localized(),
            okButtonTitle: R.string.localization.close.localized(),
            dismissActionCallback: { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }

                weakSelf.actionBack()
        })
    }

    private func applicantPresent(gift: GiftModel) {
        let giftId = gift.id

        presenter.applicantPresent(giftId)
    }
}

// MARK: - QRScannerViewDelegate

extension QRScannerViewController: QRScannerViewDelegate {

    func qrScanningDidStop() {

    }

    func qrScanningDidFail() {

    }

    func qrScanningSucceededWithCode(_ qrCode: String?) {
        let result = presenter.processQRCode(qrCode)
        guard result else {
            let alert = rx_alertWithMessage(message: "QRコードが無効です")
            _ = alert.subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {
                    return
                }

                weakSelf.startScanning()
            })

            return
        }
    }
}

// MARK: - QRScannerView1Delegate

extension QRScannerViewController: QRScannerView1Delegate {

    func didGrantPoint(_ point: String) {
        showGrantPointPopup(point)
    }

    func didVerifyPresentForApplication(status: GiftStatus, gift: GiftModel) {
        switch status {
        case .alreadyApplicant:
            presentAlreadyApplicantWarning()
        case .pointNotEnough:
            displayPointNotEnoughWarning()
        case .availability:
            applicantPresent(gift: gift)
        case .requiredInfo:
            openPresentApplication(gift: gift)
        }
    }

    func didApplicantPresent(_ message: String?) {
        if message != nil {
            return
        }

        router.openPresentApplicationDone()
    }
}
