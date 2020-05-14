//
//  BasePagerViewController.swift
//  Medicare
//
//  Created by sanghv on 12/26/19.
//

import UIKit
import XLPagerTabStrip

class BasePagerViewController: BaseViewController {

    fileprivate var itemInfo = IndicatorInfo(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func set(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }
}

extension BasePagerViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
