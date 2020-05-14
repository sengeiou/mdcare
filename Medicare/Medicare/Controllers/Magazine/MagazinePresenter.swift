//
//  MagazinePresenter.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum MagazineTabIndex: Int {
    case all = 0
    case ranking
    case favourite
    case other
}

enum MagazineCategoryType: String {
    case top
    case ranking
    case favourite
    case category
}

protocol MagazineFeelingPresenter {
    func magazineLike(_ magazineId: Int?)
    func magazineFavorite(_ magazineId: Int?, isFavorite: Int?, completion: @escaping () -> Void)
}

extension MagazineFeelingPresenter {

    func magazineLike(_ magazineId: Int?) {}

    func magazineFavorite(_ magazineId: Int?, isFavorite: Int?, completion: @escaping () -> Void) {
        let params = [
            "magazine_id": magazineId ?? 0,
            "is_favorite": (isFavorite == 1) ? 0 : 1
        ]
        showHUDActivity()
        let gateway = MagazineGateway()
        gateway.favorite(params) { (_) in
            popHUDActivity()
            completion()
        }
    }
}

protocol MagazinePresenterDelegate: class {
    func showMagazineTabCompleted(_ categoryList: [MagazineCategoryModel])
    func loadMagazinesCompleted(_ magazineItems: [MagazineModel], error: String?)
    func likeCompleted(_ like: LikeModel?)
}

extension MagazinePresenterDelegate {
    func showMagazineTabCompleted(_ categoryList: [MagazineCategoryModel]) {}
    func loadMagazinesCompleted(_ magazineItems: [MagazineModel], error: String?) {}
    func likeCompleted(_ like: LikeModel?) {}
}

final class MagazinePresenter: MagazineFeelingPresenter {

    weak var delegate: MagazinePresenterDelegate?

    func showMagazineTab() {
        showHUDActivity()
        let gateWay = MagazineGateway()
        gateWay.getCategoryList { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let items = Mapper<MagazineCategoryModel>().mapArray(JSONString: json["data"].rawString() ?? "")
                self?.getCategoryList(items?.filter({ $0.magazineSelected == true }))
            }
        }
    }

    fileprivate func getCategoryList(_ categoryList: [MagazineCategoryModel]?) {
        var items = [MagazineCategoryModel]()

        let  item1 = MagazineCategoryModel()
        item1.id = -1
        item1.name = R.string.localization.magazineStringTabAll.localized()
        item1.isSelected = true
        item1.type = .all

        let  item2 = MagazineCategoryModel()
        item2.id = -2
        item2.name = R.string.localization.magazineStringTabRanking.localized()
        item2.isSelected = false
        item2.type = .ranking

        let  item3 = MagazineCategoryModel()
        item3.id = -3
        item3.name = R.string.localization.magazineStringTabFavourite.localized()
        item3.isSelected = false
        item3.type = .favourite

        items.append(item1)
        items.append(item2)
        items.append(item3)

        if let categoryList = categoryList {
            items.append(contentsOf: categoryList)
        }

        delegate?.showMagazineTabCompleted(items)
    }

    func loadMagazines(_ params: [String: Any], showHUD: Bool = true) {
        if showHUD {
            showHUDActivity()
        }
        let gateway = MagazineGateway()
        gateway.getMagazineList(params, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let items = Mapper<MagazineModel>().mapArray(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.loadMagazinesCompleted(items ?? [], error: nil)
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.loadMagazinesCompleted([], error: error)
        })
    }

    func magazineLike(_ magazineId: Int?) {
        showHUDActivity()
        let gateway = MagazineGateway()
        gateway.like(magazineId ?? 0) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let like = Mapper<LikeModel>().map(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.likeCompleted(like)
            }
        }
    }
}
