//
//  TabBarItem.swift
//  Medicare
//
//  Created by sanghv on 12/26/19.
//

import UIKit

final class TabBarItem: ESTabBarItem {

    override init(_ contentView: ESTabBarItemContentView = ESTabBarItemContentView(),
                  title: String? = nil,
                  image: UIImage? = nil,
                  selectedImage: UIImage? = nil,
                  tag: Int = 0) {
        let image = image?.withRenderingMode(.alwaysTemplate)
        let selectedImage = selectedImage?.withRenderingMode(.alwaysTemplate)
        super.init(contentView,
                   title: title,
                   image: image,
                   selectedImage: selectedImage,
                   tag: tag)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
