//
//  DetailGiftRoute.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

protocol DetailMagazineRoute {
    func openMagazineDetailView(_ magazine: MagazineModel?)
}

extension DetailMagazineRoute where Self: RouterProtocol {

    func openMagazineDetailView(_ magazine: MagazineModel?) {
        let router = DetailMagazineRouter()
        let detailViewController = DetailMagazineViewController.newInstance().then {
            $0.route = router
            $0.magazine = magazine
        }
        router.viewController = detailViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(detailViewController, transition: trans)
    }
}
