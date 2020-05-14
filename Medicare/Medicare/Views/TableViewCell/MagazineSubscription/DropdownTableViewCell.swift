//
//  DropdownTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit
import DropDown

protocol DropdownTableViewCellDelegate: class {
    func openDropDown(from cell: DropdownTableViewCell)
    // func updateValue(_ value: String, row: Int)
}

final class DropdownTableViewCell: RequiredValueTableViewCell {

    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var requiredView: UIView!
    @IBOutlet fileprivate(set) weak var requiredLabel: UILabel!

    fileprivate lazy var dropDown: DropDown = {
        let dropDown = DropDown().then {
            $0.direction = .bottom
            $0.dismissMode = .onTap
            $0.textFont = .regular(size: 16.0)
            $0.textColor = ColorName.c333333.color
            $0.dropShadowForContainer()
        }

        return dropDown
    }()

    public var isRequired: Bool = true {
        didSet {
            requiredView.isHidden = !isRequired
        }
    }

    public var isTitleVisble: Bool = false {
        didSet {
            titleLabel.isHidden = !isTitleVisble
            requiredView.isHidden = !isTitleVisble
        }
    }

    fileprivate var selectRow: Int?
    fileprivate var dataSource: [String] = []
    public var isPrefectureSelection: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configRequiredView()
        configLabels()
        configTextFields()
    }

    private func configRequiredView() {
        _ = requiredView?.then {
            $0.backgroundColor = ColorName.cE84680.color
            $0.cornerRadius = $0.frame.height / 2
        }
    }

    private func configLabels() {
        _ = titleLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 18.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            $0.text = nil
        }

        _ = requiredLabel.then {
            $0.textColor = ColorName.white.color
            $0.font = .medium(size: 13.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        isTitleVisble = false
    }

    private func configTextFields() {
        let textFields: [UITextField] = [
            leftTextField
        ]

        textFields.forEach {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16.0)
            $0.rightViewMode = .always
            $0.isUserInteractionEnabled = true
            $0.delegate = self
        }

        let imageViewRect = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        let imageView = UIImageView(frame: imageViewRect).then {
            $0.image = R.image.dropdown()
            $0.contentMode = .center
        }
        leftTextField.rightView = imageView
    }

    override var isLeftTextEmpty: Bool {
        var isLeftTextEmpty = super.isLeftTextEmpty
        if isPrefectureSelection {
            let isDefaultText = leftTextField?.text?.trim() == R.string.localization.prefectures.localized()
            isLeftTextEmpty = isLeftTextEmpty || isDefaultText
        }

        return isLeftTextEmpty
    }
}

// MARK: - Actions

extension DropdownTableViewCell {

    private func showDropdown() {
        _ = dropDown.then {
            $0.anchorView = leftTextField
            $0.bottomOffset = CGPoint(x: 0, y: ($0.anchorView?.plainView.bounds.height)!)
        }

        dropDown.dataSource = dataSource
        if !dropDown.dataSource.isEmpty {
            dropDown.selectRow(at: selectRow)
        }

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            guard let weakSelf = self else {
                return
            }

            weakSelf.updateValue(item, row: index)
        }

        dropDown.show()
    }

    func updateValue(_ value: String, row: Int) {
        leftTextField.text = value
        selectRow = row

        // (delegate as? DropdownTableViewCellDelegate)?.updateValue(value, row: row)
    }

    private func openDropDown() {
        (delegate as? DropdownTableViewCellDelegate)?.openDropDown(from: self)
    }
}

extension DropdownTableViewCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        openDropDown()

        return false
    }
}

extension DropdownTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (selectRow, value, dataSource) = data as? (Int?, String, [String]) else {
            return
        }

        self.selectRow = selectRow
        self.leftTextField.text = value
        self.dataSource = dataSource
    }
}
