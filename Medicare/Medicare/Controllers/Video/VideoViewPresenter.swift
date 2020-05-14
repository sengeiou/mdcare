//
//  VideoViewPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/25/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum VideoTabIndex: Int {
    case none = -1
    case videoList = 0
    case channelList
    case ranking
    case favourite
}

enum VideoCategoryType: String {
    case top
    case ranking
    case favourite
    case channel
}

protocol VideoFeelingPresenter {
    func videoLike(_ videoId: Int?)
    func videoFavorite(_ videoId: Int?, isFavorite: Int?, completion: @escaping () -> Void)
}

extension VideoFeelingPresenter {

    func videoLike(_ videoId: Int?) {}

    func videoFavorite(_ videoId: Int?, isFavorite: Int?, completion: @escaping () -> Void) {
        let params = [
            "movie_id": videoId ?? 0,
            "is_favorite": (isFavorite == 1) ? 0 : 1
        ]
        showHUDActivity()
        let gateway = VideoGateway()
        gateway.favorite(params) { (_) in
            popHUDActivity()
            completion()
        }
    }
}

protocol VideoViewPresenterDelegate: class {
    func showVideoTabCompleted(_ categoryList: [VideoCategoryModel])
    func loadVideosCompleted(_ videoItems: [VideoModel], error: String?)
    func loadChannelsCompleted(_ channelItems: [VideoChannelModel])
    func likeCompleted(_ like: LikeModel?)
}

extension VideoViewPresenterDelegate {
    func showVideoTabCompleted(_ categoryList: [VideoCategoryModel]) {}
    func loadVideosCompleted(_ videoItems: [VideoModel], error: String?) {}
    func loadChannelsCompleted(_ channelItems: [VideoChannelModel]) {}
    func likeCompleted(_ like: LikeModel?) {}
}

final class VideoViewPresenter: VideoFeelingPresenter {

    weak var delegate: VideoViewPresenterDelegate?

    func showVideoTab() {
        var categoryList = [VideoCategoryModel]()

        let  item1 = VideoCategoryModel()
        item1.name = R.string.localization.videoTabVideoList.localized()
        item1.isSelected = true
        item1.type = .videoList

        let  item2 = VideoCategoryModel()
        item2.name = R.string.localization.videoString002.localized()
        item2.isSelected = false
        item2.type = .channelList

        let  item3 = VideoCategoryModel()
        item3.name = R.string.localization.videoString003.localized()
        item3.isSelected = false
        item3.type = .ranking

        let  item4 = VideoCategoryModel()
        item4.name = R.string.localization.videoString004.localized()
        item4.isSelected = false
        item4.type = .favourite

        categoryList.append(item1)
        categoryList.append(item2)
        categoryList.append(item3)
        categoryList.append(item4)

        delegate?.showVideoTabCompleted(categoryList)
    }

    func loadVideos(_ tabIndex: VideoTabIndex, channelId: Int?, pageSize: Int, pageIndex: Int, showHUD: Bool = true) {
        var type = ""
        switch tabIndex {
        case .channelList:
            type = VideoCategoryType.channel.rawValue
        case .ranking:
            type = VideoCategoryType.ranking.rawValue
        case .favourite:
            type = VideoCategoryType.favourite.rawValue
        default:
            type = MagazineCategoryType.top.rawValue
        }

        let params: [String: Any] = [
            "type": type,
            "channel_id": channelId ?? 0,
            "page_size": pageSize,
            "page_index": pageIndex
        ]

        if showHUD {
            showHUDActivity()
        }
        let gateway = VideoGateway()
        gateway.getMovieList(params, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let items = Mapper<VideoModel>().mapArray(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.loadVideosCompleted(items ?? [], error: nil)
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.loadVideosCompleted([], error: error)
        })
    }

    func loadChannels(showHUD: Bool = true) {
        if showHUD {
            showHUDActivity()
        }
        let gateWay = VideoGateway()
        gateWay.getChannelList { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let items = Mapper<VideoChannelModel>().mapArray(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.loadChannelsCompleted(items ?? [])
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
                self?.delegate?.likeCompleted(like)
            }
        }
    }
}
