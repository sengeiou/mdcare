//
//  QRScannerPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol QRScannerView1Delegate: class {
    func didGrantPoint(_ point: String)
    func didVerifyPresentForApplication(status: GiftStatus, gift: GiftModel)
    func didApplicantPresent(_ message: String?)
}

struct QRCodeKey {
    static let target_id = "target_id"
    static let type      = "type"
}

enum QRCodeType: Int {
    case none = 0, grant, presentApplication
}

final class QRScannerPresenter {

    fileprivate weak var delegate: QRScannerView1Delegate?

    convenience init(delegate: QRScannerView1Delegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: QRScannerView1Delegate) {
        self.delegate = delegate
    }
}

extension QRScannerPresenter {

    func processQRCode(_ qrCode: String?) -> Bool {
        guard let qrCode = qrCode else {
            return false
        }

        let jwt = decode(jwtToken: qrCode)
        let json = JSON(rawValue: jwt)?[ResponseKey.data]

        var targetIdTemp: Int?
        if let id = json?[QRCodeKey.target_id].rawValue as? Int {
            targetIdTemp = id
        } else if let id = json?[QRCodeKey.target_id].rawValue as? String {
            targetIdTemp = Int(id)
        }

        var typeTemp: Int?
        if let type = json?[QRCodeKey.type].rawValue as? Int {
            typeTemp = type
        } else if let type = json?[QRCodeKey.type].rawValue as? String {
            typeTemp = Int(type)
        }

        guard let targetId = targetIdTemp,
            let type = typeTemp, let qrCodeType = QRCodeType(rawValue: type) else {
                return false
        }

        switch qrCodeType {
        case .grant:
            let info: [String: Any] = [
                QRCodeKey.target_id: targetId,
                QRCodeKey.type: PointGrantType.event.rawValue
            ]
            grantPointWith(info)
        case .presentApplication:
            getPresentFor(targetId: targetId)
        default:
            break
        }

        return true
    }

    private func getPresentFor(targetId: Int) {
        showHUDIfInvisible()
        GiftGateway().getPresentDetail(targetId) { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON,
                let gift = Mapper<GiftModel>().map(
                    JSONObject: json[ResponseKey.data].dictionaryObject
                ) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.processPresent(gift)
        }
    }

    private func processPresent(_ present: GiftModel) {
        getUserInfo(success: { [weak self] in
            guard let weakSelf = self else {
                return
            }

            weakSelf.verifyPresentAppicationWith(present: present)
        })
    }

    private func getUserInfo(success: GetUserInfoSuccessClosure? = nil) {
        showHUDIfInvisible()
        AuthenticationGateway().getUserInfo(success: { (response) in
            dismissHUD()

            guard let json = response as? JSON else {
                return
            }

            guard let user = Mapper<UserModel>().map(JSONObject: json[ResponseKey.data].dictionaryObject) else {
                return
            }

            ShareManager.shared.setCurentUser(user)

            success?()
        }, failure: nil)
    }

    private func grantPointWith(_ info: [String: Any]) {
        showHUDIfInvisible()
        PointGateway().earnPoint(info: info, success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let weakSelf = self else {
                return
            }

            var pointTemp: String = TSConstants.ZERO_STRING
            if let point = json[ResponseKey.data]["point"].rawValue as? Int {
                pointTemp = point.toString()
            } else if let point = json[ResponseKey.data]["point"].rawValue as? String {
                pointTemp = point
            }

            weakSelf.delegate?.didGrantPoint(pointTemp)
        }, failure: nil)
    }

    private func verifyPresentAppicationWith(present: GiftModel) {
        let giftStatus = DetailGiftPresenter.getStatusOf(gift: present)
        delegate?.didVerifyPresentForApplication(status: giftStatus, gift: present)
    }

    func applicantPresent(_ presentId: Int) {
        let data: [String: Any] = [:]
        showHUDIfInvisible()
        PresentApplicationGateway().applicant(presentId: presentId, data: data, success: { [weak self] (_) in
            popHUDActivity()

            guard let weakSelf = self else {
                return
            }

            weakSelf.delegate?.didApplicantPresent(nil)
        }, failure: { [weak self] (message) in
            guard let weakSelf = self else {
                return
            }

            weakSelf.delegate?.didApplicantPresent(message)
        })
    }
}
