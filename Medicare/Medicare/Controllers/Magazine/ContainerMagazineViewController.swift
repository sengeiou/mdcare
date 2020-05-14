//
//  ContainerMagazineViewController.swift
//  Medicare
//
//  Created by Thuan on 3/13/20.
//

import UIKit
import XLPagerTabStrip

final class ContainerMagazineViewController: BaseButtonBarPagerTabStripViewController<MagazineTabCollectionViewCell> {

    // MARK: Variables

    var categoryList = [MagazineCategoryModel]()
    fileprivate var selectedIndex = 0

    override func viewDidLoad() {

        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "MagazineTabCollectionViewCell",
                                                      bundle: Bundle(for: MagazineTabCollectionViewCell.self),
                                                      width: { _ in
                                                        return 100.0
        })

        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .clear
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 30

        changeCurrentIndexProgressive = { (oldCell: MagazineTabCollectionViewCell?,
                                            newCell: MagazineTabCollectionViewCell?,
                                            progressPercentage: CGFloat,
                                            changeCurrentIndex: Bool,
                                            animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.selectedItem(false)
            newCell?.selectedItem(true)
        }

        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setTabBarVisible(true, animated: false)
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        categoryList[selectedIndex].isSelected = false
        selectedIndex = indexPath.row
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var views = [UIViewController]()
        for category in categoryList {
            let vc = ContentMagazineViewController.newInstance()
            vc.parentVC = self
            vc.category = category
            vc.itemInfo = IndicatorInfo(title: category.name,
                                         image: nil, highlightedImage: nil,
                                         userInfo: category.id)
            views.append(vc)
        }

        return views
    }

    override func configure(cell: MagazineTabCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        if let userInfo = indicatorInfo.userInfo as? Int {
            let item = categoryList.first(where: { $0.id == userInfo })
            cell.selectedItem(item?.isSelected ?? false)
            cell.extendPaddingLeft(item?.type == .all)
        }
        UIView.performWithoutAnimation {
            cell.btnChannel.setTitle(indicatorInfo.title, for: .normal)
            cell.btnChannel.layoutIfNeeded()
        }
    }

    override func updateIndicator(for viewController: PagerTabStripViewController,
                                  fromIndex: Int, toIndex: Int,
                                  withProgressPercentage progressPercentage: CGFloat,
                                  indexWasChanged: Bool) {
        super.updateIndicator(for: viewController,
                              fromIndex: fromIndex, toIndex: toIndex,
                              withProgressPercentage: progressPercentage,
                              indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count && toIndex == selectedIndex {
            categoryList[toIndex].isSelected = true
            buttonBarView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let item = categoryList[indexPath.row]
        let size = sizeLabel(item.name ?? "")
        var widthItem = size.width
        if item.type == .all {
            widthItem += 10
        }
        return CGSize(width: widthItem, height: 30)
    }
}
