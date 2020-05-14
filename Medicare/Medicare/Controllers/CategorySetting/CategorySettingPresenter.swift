//
//  CategorySettingPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol CategorySettingViewDelegate: class {
    func didLoadCategory()
    func didLoadTag()
    func didUpdateCategory()
}

final class CategorySettingPresenter {

    fileprivate let gateway = CategoryGateway()
    fileprivate weak var delegate: CategorySettingViewDelegate?

    fileprivate let sections = [CategorySettingSection.category] // CategorySettingSection.allCases
    fileprivate var categoriesList: [CategoryModel] = []
    fileprivate var tagsList: [String] = []

    convenience init(delegate: CategorySettingViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: CategorySettingViewDelegate) {
        self.delegate = delegate
    }
}

extension CategorySettingPresenter {

    func loadCategory() {
        showHUDAndAllowUserInteractionEnabled()
        gateway.getCategoryList(success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let categories = Mapper<CategoryModel>().mapArray(
                JSONObject: json[ResponseKey.data].arrayObject) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.categoriesList = categories

            weakSelf.delegate?.didLoadCategory()
        }, failure: nil)
    }

    func loadTag() {
        guard let jsonUrl = R.file.tagsListJson() else {
            return
        }

        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue(label: "", qos: .background).async { [weak self] in
            guard let data = FileManagerHelper.shared.getContentsOf(jsonUrl) else {
                return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.tagsList = (JSON(rawValue: data)?.arrayObject as? [String]) ?? []

            DispatchQueue.main.async {
                popHUDActivity()
                weakSelf.delegate?.didLoadTag()
            }
        }
    }

    private func getCategoryIdsAt(rows: [Int]) -> [Int] {
        var ids = [Int]()
        for row in rows {
            let categoryId = categoryAt(row: row).id
            guard categoryId != 0 else {
                continue
            }

            ids.append(categoryId)
        }

        return ids
    }

    func updateSelectedCategoriesAt(rows: [Int]) {
        let ids = getCategoryIdsAt(rows: rows)

        showHUDAndAllowUserInteractionEnabled()
        gateway.updateCategory(ids: ids, success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let categories = Mapper<CategoryModel>().mapArray(
                JSONObject: json[ResponseKey.data].arrayObject) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.categoriesList = categories

            weakSelf.delegate?.didUpdateCategory()
        }, failure: nil)
    }
}

extension CategorySettingPresenter {

    var numberOfSections: Int {
        return sections.count
    }

    func sectionTitleAt(section: Int) -> String {
        guard section < numberOfSections else {
            return TSConstants.EMPTY_STRING
        }

        return sections[section].title
    }

    func numberOfRowsAt(section: Int) -> Int {
        let sectionType = CategorySettingSection(raw: section)
        switch sectionType {
        case .category:
            return numberOfCategories
        default:
            return numberOfTags
        }
    }

    func valueAt(indexPath: IndexPath) -> Any {
        let sectionType = CategorySettingSection(raw: indexPath.section)
        switch sectionType {
        case .category:
            return categoryNameAt(row: indexPath.row)
        default:
            return tagAt(row: indexPath.row)
        }
    }

    func isSelectedAt(indexPath: IndexPath) -> Bool {
        let sectionType = CategorySettingSection(raw: indexPath.section)
        switch sectionType {
        case .category:
            return categoryAt(row: indexPath.row).selected
        default:
            return false
        }
    }

    private var numberOfCategories: Int {
        return categoriesList.count
    }

    private func categoryAt(row: Int) -> CategoryModel {
        guard row < numberOfCategories else {
            return CategoryModel()
        }

        let category = categoriesList[row]

        return category
    }

    private func categoryNameAt(row: Int) -> String {
        let category = categoryAt(row: row)

        return category.name
    }

    private var numberOfTags: Int {
        return tagsList.count
    }

    private func tagAt(row: Int) -> String {
        guard row < numberOfTags else {
            return TSConstants.EMPTY_STRING
        }

        return tagsList[row]
    }
}
