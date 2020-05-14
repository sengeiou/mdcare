//
//  MagazineModel.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import ObjectMapper

final class MagazineModel: BaseModel {

    // MARK: - Properties

    var title: String?
    var url: String?
    var img_path: URL?
    var start_at: String?
    var end_at: String?
    var status: Int?
    var point: Int?
    var pv: Int?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?
    var favorite_flg: Int?
    var good: Int?
    var good_flg: Int?
    var category: [MagazineCategoryModel]?

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.title <- map["title"]
        self.url <- map["url"]
        self.img_path <- (map["img_path"], URLTransform())
        self.start_at <- map["start_at"]
        self.end_at <- map["end_at"]
        self.status <- (map["status"], IntTransform())
        self.point <- (map["point"], IntTransform())
        self.pv <- (map["pv"], IntTransform())
        self.created_at <- map["created_at"]
        self.updated_at <- map["updated_at"]
        self.deleted_at <- map["deleted_at"]
        self.favorite_flg <- (map["favorite_flg"], IntTransform())
        self.good <- (map["good"], IntTransform())
        self.good_flg <- (map["good_flg"], IntTransform())
        self.category <- map["category"]
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
}

extension MagazineModel: MediaProtocol {

    var name: String {
        return title ?? TSConstants.EMPTY_STRING
    }

    var imageUrl: URL? {
        return img_path
    }
}
