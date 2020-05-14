//
//  ContainerVideoViewController.swift
//  Medicare
//
//  Created by Thuan on 3/9/20.
//

import UIKit
import XLPagerTabStrip

typealias ContainerVideoReloadTitle = (Int) -> Void

protocol ContainerVideoViewControllerDelegate: class {
    func didSelectChannelList()
    func didBackToChannelList()
}

final class ContainerVideoViewController: BaseButtonBarPagerTabStripViewController<MagazineTabCollectionViewCell> {

    // MARK: Variables

    var reloadTitle: ContainerVideoReloadTitle?
    var categoryList = [VideoCategoryModel]()
    fileprivate var selectedIndex = 0
    fileprivate var views = [UIViewController]()
    weak var customDelegate: ContainerVideoViewControllerDelegate?

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

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        for category in categoryList {
            let vc = ContentVideoViewController.newInstance()
            vc.delegate = self
            vc.parentVC = self
            vc.videoTabIndex = category.type
            vc.itemInfo = IndicatorInfo(title: category.name,
                                         image: nil, highlightedImage: nil,
                                         userInfo: category.type)
            views.append(vc)
        }

        return views
    }

    override func configure(cell: MagazineTabCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        if let userInfo = indicatorInfo.userInfo as? VideoTabIndex {
            let item = categoryList.first(where: { $0.type == userInfo })
            cell.selectedItem(item?.isSelected ?? false)
            cell.extendPaddingLeft(item?.type == .videoList)
        }
        UIView.performWithoutAnimation {
            cell.btnChannel.setTitle(indicatorInfo.title, for: .normal)
            cell.btnChannel.layoutIfNeeded()
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let item = categoryList[indexPath.row]
        let size = sizeLabel(item.name ?? "")
        var widthItem = size.width
        if item.type == .videoList {
            widthItem += 10
        }
        return CGSize(width: widthItem, height: 30)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reloadTitle?(indexPath.row)
        setTabBarVisible(true, animated: false)
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        categoryList[selectedIndex].isSelected = false
        selectedIndex = indexPath.row

        if selectedIndex < views.count,
            let view = views[selectedIndex] as? ContentVideoViewController {
            view.dismissChannelDetailIfNeeded()
        }
    }

    override func updateIndicator(for viewController: PagerTabStripViewController,
                                  fromIndex: Int,
                                  toIndex: Int,
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
}

extension ContainerVideoViewController: ContentVideoViewControllerDelegate {

    func didSelectChannelList() {
        customDelegate?.didSelectChannelList()
    }

    func didBackToChannelList() {
        customDelegate?.didBackToChannelList()
    }
}
