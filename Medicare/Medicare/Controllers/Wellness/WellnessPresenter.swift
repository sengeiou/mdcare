//
//  WellnessPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol WellnessViewDelegate: class {
    func didLoadCategory()
}

final class WellnessPresenter {

    fileprivate let gateway = WellnessGateway()
    fileprivate weak var delegate: WellnessViewDelegate?

    fileprivate var categories: [CategoryModel] = []

    convenience init(delegate: WellnessViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: WellnessViewDelegate) {
        self.delegate = delegate
    }
}

extension WellnessPresenter {

    func loadCategory() {
        showHUDAndAllowUserInteractionEnabled()
        gateway.getWellness(success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            var categories: [CategoryModel] = []
            if let media = Mapper<MagazineModel>().mapArray(
                JSONObject: json[ResponseKey.data]["magazines"].arrayObject), !media.isEmpty {
                let category = CategoryModel().then {
                    $0.name = R.string.localization.magazineStringTitle.localized()
                    $0.media = media
                    $0.wellnessType = .magazine
                }
                categories.append(category)
            }

            if let media = Mapper<VideoModel>().mapArray(
                JSONObject: json[ResponseKey.data]["movies"].arrayObject), !media.isEmpty {
                let category = CategoryModel().then {
                    $0.name = R.string.localization.tabBarString004.localized()
                    $0.media = media
                    $0.wellnessType = .video
                }
                categories.append(category)
            }

            if let media = Mapper<GiftModel>().mapArray(
                JSONObject: json[ResponseKey.data]["presents"].arrayObject), !media.isEmpty {
                let category = CategoryModel().then {
                    $0.name = R.string.localization.tabBarString002.localized()
                    $0.media = media
                    $0.wellnessType = .present
                }
                categories.append(category)
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.categories = categories

            weakSelf.delegate?.didLoadCategory()
        }, failure: nil)
    }
}

extension WellnessPresenter {

    var numberOfSections: Int {
        return categories.count
    }

    func sectionTitleAt(section: Int) -> String {
        return categoryAt(section: section).name
    }

    func numberOfRowsAt(section: Int) -> Int {
        let category = categoryAt(section: section)

        return category.media.count
    }

    func shouldShowPlayIconAt(section: Int) -> Bool {
        /*
        let category = categoryAt(section: section)

        return category.id == 2
        */

        return false
    }

    func categoryTypeAt(section: Int) -> WellnessType {
        let category = categoryAt(section: section)

        return category.wellnessType
    }

    private func categoryAt(section: Int) -> CategoryModel {
        guard section < numberOfSections else {
            return CategoryModel()
        }

        return categories[section]
    }

    func mediaAt(indexPath: IndexPath) -> MediaProtocol? {
        let section = indexPath.section
        let row = indexPath.row
        let category = categoryAt(section: section)
        guard row < category.media.count else {
            return nil
        }

        return category.media[row]
    }
}
