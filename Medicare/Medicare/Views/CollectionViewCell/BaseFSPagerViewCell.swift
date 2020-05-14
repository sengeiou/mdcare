//
//  BaseFSPagerViewCell.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import UIKit
import FSPagerView

open class BaseFSPagerViewCell: FSPagerViewCell {

    deinit {

    }

    open weak var delegate: AnyObject?
    open var indexPath: IndexPath?

    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.configView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.configView()
    }

    open func setIndexPath(indexPath: IndexPath?, sender: AnyObject?) {
        self.indexPath = indexPath
        self.delegate = sender
    }
}

@objc extension BaseFSPagerViewCell {

    open func configView() {
        contentView.layer.shadowRadius = 0
    }
}

@objc public extension BaseFSPagerViewCell {

    // MARK: - Reuse identifer

    class var identifier: String {
        let mirror = Mirror(reflecting: self)
        return "\(String(describing: mirror.subjectType).replacingOccurrences(of: ".Type", with: ""))ID"
    }
}

@objc extension BaseFSPagerViewCell: TSCellDatasource {

    // MARK: - TSCellDatasource

    open class var cellIdentifier: String {
        return "CellIdentifier"
    }

    open func configCellWithData(data: Any?) {

    }
}
