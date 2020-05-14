//
//  UnregisterPresenter.swift
//  Medicare
//
//  Created by Thuan on 4/17/20.
//

import Foundation

protocol UnregisterPresenterDelegate: class {
    func unregisterCompleted()
}

class UnregisterPresenter {

    weak var delegate: UnregisterPresenterDelegate?

    func unregister() {
        showHUDActivity()
        let gateWay = UserGateway()
        gateWay.unregister { [weak self] (_) in
            popHUDActivity()
            self?.delegate?.unregisterCompleted()
        }
    }
}
