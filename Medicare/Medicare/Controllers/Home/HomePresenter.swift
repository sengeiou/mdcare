//
//  HomePresenter.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol HomePresenterDelegate: class {
    func loadDataCompleted(_ magazineItems: [MagazineModel],
                           videoItems: [VideoModel],
                           giftItems: [GiftModel])
    func magazineLikeCompleted(_ like: LikeModel?)
    func videoLikeCompleted(_ like: LikeModel?)
}

final class HomePresenter: MagazineFeelingPresenter, VideoFeelingPresenter {

    weak var delegate: HomePresenterDelegate?

    func loadData(showHUD: Bool = true) {
        if showHUD {
            showHUDActivity()
        }
        let gateWay = HomeGateway()
        gateWay.getTopData { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                if let data = json["data"].dictionaryObject {
                    let magazineItems = Mapper<MagazineModel>().mapArray(JSONObject: data["magazine"])
                    let videoItem = Mapper<VideoModel>().map(JSONObject: data["movie"])
                    let giftItems = Mapper<GiftModel>().mapArray(JSONObject: data["present"])

                    self?.delegate?.loadDataCompleted(magazineItems ?? [],
                                                      videoItems: (videoItem != nil) ? [videoItem!] : [],
                                                      giftItems: giftItems ?? [])
                }
            }
        }
    }

    func magazineLike(_ magazineId: Int?) {
        showHUDActivity()
        let gateway = MagazineGateway()
        gateway.like(magazineId ?? 0) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let like = Mapper<LikeModel>().map(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.magazineLikeCompleted(like)
            }
        }
    }

    func videoLike(_ videoId: Int?) {
        showHUDActivity()
        let gateway = VideoGateway()
        gateway.like(videoId ?? 0) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let like = Mapper<LikeModel>().map(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.videoLikeCompleted(like)
            }
        }
    }
}
