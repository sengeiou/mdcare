//
//  VideoModel.swift
//  Medicare
//
//  Created by Thuan on 3/24/20.
//

import Foundation
import ObjectMapper

final class VideoModel: BaseModel {

    // MARK: - Properties

    var title: String?
    var desc: String?
    var img_path: URL?
    var url: String?
    var point: Int?
    var pv: Int?
    var created_at: String?
    var channel_title: String?
    var channel_img_path: URL?
    var favorite_flg: Int?
    var good: Int?
    var good_flg: Int?
    var category: [VideoCategoryModel]?
    var time: Int?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.title <- map["title"]
        self.desc <- map["description"]
        self.img_path <- (map["img_path"], URLTransform())
        self.url <- map["url"]
        self.point <- (map["point"], IntTransform())
        self.pv <- (map["pv"], IntTransform())
        self.created_at <- map["created_at"]
        self.channel_title <- map["channel_title"]
        self.channel_img_path <- (map["channel_img_path"], URLTransform())
        self.favorite_flg <- (map["favorite_flg"], IntTransform())
        self.good <- (map["good"], IntTransform())
        self.good_flg <- (map["good_flg"], IntTransform())
        self.category <- map["category"]
        self.time <- (map["time"], IntTransform())
    }

    func categoryName() -> String {
        guard let category = category else {
            return ""
        }

        var categoryName = ""
        for cate in category {
            categoryName += "\(cate.name ?? ""),"
        }
        if !categoryName.isEmpty {
            return String(categoryName.dropLast())
        }
        return categoryName
    }

    var isLiked: Bool {
        return good_flg == 1
    }

    var isFavorited: Bool {
        return favorite_flg == 1
    }

    var videoId: String {
        if let url = url {
            var newUrl = url
            var split = url.components(separatedBy: "&")
            if !split.isEmpty {
                newUrl = split[0]
            }
            if !newUrl.contains("http") {
                return newUrl
            }
            split = newUrl.components(separatedBy: "=")
            if split.count > 1 {
                return split[1]
            }
        }
        return ""
    }
}

extension VideoModel: MediaProtocol {

    var name: String {
        return title ?? TSConstants.EMPTY_STRING
    }

    var imageUrl: URL? {
        return img_path
    }
}
