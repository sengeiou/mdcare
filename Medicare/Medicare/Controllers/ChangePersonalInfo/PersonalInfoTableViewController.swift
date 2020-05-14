//
//  PersonalInfoTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

class PersonalInfoTableViewController: BaseTableViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var fullNameCell: LeftRightInputTableViewCell!
    @IBOutlet weak var fullNameKanaCell: LeftRightInputTableViewCell!
    @IBOutlet weak var genderCell: DropdownTableViewCell!
    @IBOutlet weak var birthdayCell: LeftInputRightButtonTableViewCell!
    @IBOutlet weak var phoneNumberCell: LeftInputRightButtonTableViewCell!
    @IBOutlet weak var zipcodeCell: LeftInputRightButtonTableViewCell!
    @IBOutlet weak var prefectureCell: DropdownTableViewCell!
    @IBOutlet weak var cityCell: InputOnlyTableViewCell!
    @IBOutlet weak var addressCell: InputOnlyTableViewCell!
    @IBOutlet weak var buildingCell: InputOnlyTableViewCell!

    fileprivate var stringPicker: ActionSheetStringPicker?
    fileprivate var datePicker: ActionSheetDatePicker?

    lazy var userInfoCells: [TSBaseTableViewCell] = {
        return [
            fullNameCell,
            fullNameKanaCell,
            genderCell,
            birthdayCell,
            phoneNumberCell,
            zipcodeCell,
            prefectureCell,
            cityCell,
            addressCell,
            buildingCell
        ]
    }()

    var indexPathForStaticCells: [UITableViewCell: IndexPath] = [:]

    // MARK: - Variable

    var basePresenter: UserInfoPresenter {
        return UserInfoPresenter()
    }

    var baseRouter: PersonalInfoRouter {
        return PersonalInfoRouter()
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func loadData() {
        basePresenter.loadPrefecture()
        basePresenter.getUserInfo()
    }
}

extension PersonalInfoTableViewController {

    override func configView() {
        super.configView()

        basePresenter.set(delegate: self)
        configTableView()
        addFullNameCellActions()
        addFullNameCellKanaActions()
        addGenderCellActions()
        addBirthdayCellActions()
        addPhoneNumberCellActions()
        addZipcodeCellActions()
        addPrefectureCellActions()
        addCityCellActions()
        addAddressCellActions()
        addBuildingCellActions()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        configCells()
    }

    @objc func configTableView() {
        _ = tableView.then {
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.showsVerticalScrollIndicator = false
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView(frame: CGRect(
                origin: .zero,
                size: CGSize(width: 0, height: 20)
            ))
        }
        extendBottomInsetIfNeed(for: tableView)
    }

    @objc func configCells() {
        configUserInfoCells()
        configUserAddressCells()
    }

    private func configUserInfoCells() {
        _ = fullNameCell.then {
            $0.titleLabel.text = R.string.localization.fullname.localized()
            $0.leftTextField.placeholder = R.string.localization.surname.localized()
            $0.rightTextField.placeholder = R.string.localization.name.localized()
            $0.leftTextField.delegate = self
            $0.rightTextField.delegate = self
        }

        _ = fullNameKanaCell.then {
            $0.titleLabel.text = R.string.localization.nameKana.localized()
            $0.leftTextField.placeholder = R.string.localization.because.localized()
            $0.rightTextField.placeholder = R.string.localization.niece.localized()
            $0.leftTextField.delegate = self
            $0.rightTextField.delegate = self
            $0.isKatakanaNameInput = true
        }

        _ = genderCell.then {
            $0.titleLabel.text = R.string.localization.gender.localized()
            $0.leftTextField.placeholder = R.string.localization.gender.localized()
            $0.isTitleVisble = true
        }

        _ = birthdayCell.then {
            $0.titleLabel.text = R.string.localization.birthday.localized()
            $0.leftTextField.placeholder = R.string.localization.example.localized()
                + " : 1960/01/01"
            $0.leftTextField.delegate = self
        }

        _ = phoneNumberCell.then {
            $0.titleLabel.text = R.string.localization.phoneNumber.localized()
            $0.leftTextField.placeholder = R.string.localization.example.localized()
                + " : 11122223333"
            $0.leftTextField.keyboardType = .numberPad
            $0.leftTextField.delegate = self
        }
    }

    private func configUserAddressCells() {
        _ = zipcodeCell.then {
            $0.titleLabel.text = R.string.localization.streetAddress.localized()
            $0.leftTextField.placeholder = R.string.localization.example.localized()
                + " : 5300001"
            $0.leftTextField.keyboardType = .numberPad
            $0.leftTextField.delegate = self
            $0.isVisibleActionButton = true
            $0.isZipcodeInput = true
            $0.actionButton.setTitle(
                R.string.localization.postCodeSearchEngine.localized(),
                for: .normal
            )
        }

        _ = prefectureCell.then {
            $0.leftTextField.placeholder = R.string.localization.prefectures.localized()
            $0.isPrefectureSelection = true
        }

        _ = cityCell.then {
            $0.leftTextField.placeholder = "市区町村名(例：大阪市北区)"
            $0.leftTextField.delegate = self
        }

        _ = addressCell.then {
            $0.leftTextField.placeholder = "番地(例：西梅田1丁目6-8)"
            $0.leftTextField.delegate = self
        }

        _ = buildingCell.then {
            $0.leftTextField.placeholder = "ビル名(例：大阪北101号)"
            $0.leftTextField.delegate = self
        }
    }

    @objc func configErrorForCells() {
        _ = fullNameCell.then {
            $0.setError(basePresenter.verifyFullNameMessage())
        }

        _ = fullNameKanaCell.then {
            $0.setError(basePresenter.verifyFullNameKanaMessage())
        }

        _ = genderCell.then {
            $0.setError(basePresenter.verifyGenderMessage())
        }

        _ = birthdayCell.then {
            $0.setError(basePresenter.verifyBirthdayMessage())
        }

        _ = phoneNumberCell.then {
            $0.setError(basePresenter.verifyPhoneMessage())
        }

        _ = zipcodeCell.then {
            $0.setError(basePresenter.verifyZipcodeMessage())
        }

        _ = prefectureCell.then {
            $0.setError(basePresenter.verifyPrefectureMessage())
        }

        _ = cityCell.then {
            $0.setError(basePresenter.verifyCityMessage())
        }

        _ = addressCell.then {
            $0.setError(basePresenter.verifyAddressMessage())
        }

//        _ = buildingCell.then {
//            $0.setError(basePresenter.verifyBuildingMessage())
//        }
    }

    func addFullNameCellActions() {
        _ = fullNameCell.leftTextField.then {
            _ = $0.rx.controlEvent(.editingChanged)
                .takeUntil($0.rx.deallocated)
                .withLatestFrom($0.rx.text.orEmpty)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.fullNameKanaCell.leftTextField.text = text.toJPCharacter()
                    weakSelf.fullNameKanaCell.leftTextField.sendActions(for: .editingChanged)
                })

            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.last_name = text.trim()
                })
        }

        _ = fullNameCell.rightTextField.then {
            _ = $0.rx.controlEvent(.editingChanged)
                .takeUntil($0.rx.deallocated)
                .withLatestFrom($0.rx.text.orEmpty)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.fullNameKanaCell.rightTextField.text = text.toJPCharacter()
                    weakSelf.fullNameKanaCell.rightTextField.sendActions(for: .editingChanged)
                })

            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.first_name = text.trim()
                })
        }
    }

    func addFullNameCellKanaActions() {
        _ = fullNameKanaCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.last_furigana = text.trim()
                })
        }

        _ = fullNameKanaCell.rightTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.first_furigana = text.trim()
                })
        }
    }

    func addGenderCellActions() {
        genderCell.setIndexPath(indexPath: nil, sender: self)
    }

    func addBirthdayCellActions() {

    }

    func addPhoneNumberCellActions() {
        _ = phoneNumberCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.tel_no = text.trim()
                })
        }
    }

    func addZipcodeCellActions() {
        _ = zipcodeCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.zipcode = text.trim()
                })
        }

        _ = zipcodeCell.actionButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (_) in
                    guard let weakSelf = self else {
                        return
                    }

                    let zipcode = weakSelf.basePresenter.tempUserDetail.zipcode
                    weakSelf.didTapSearchZipcode(zipcode)
                })
        }
    }

    func addPrefectureCellActions() {
        prefectureCell.setIndexPath(indexPath: nil, sender: self)
    }

    func addCityCellActions() {
        _ = cityCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.city = text.trim()
                })
        }
    }

    func addAddressCellActions() {
        _ = addressCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.address = text.trim()
                })
        }
    }

    func addBuildingCellActions() {
        _ = buildingCell.leftTextField.then {
            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.basePresenter.tempUserDetail.building = text.trim()
                })
        }
    }

    private func configStringPicker(at view: UIView, initialSelection: Int, data: [String]) {
        let doneAction: ActionStringDoneBlock = { [weak self] picker, index, value in
            guard let weakSelf = self else {
                return
            }

            guard let value = value as? String else {
                return
            }

            weakSelf.updateValue(value, row: index, at: view)
        }

        let stringPicker = ActionSheetStringPicker(title: TSConstants.EMPTY_STRING,
                                                   rows: data,
                                                   initialSelection: initialSelection,
                                                   doneBlock: doneAction,
                                                   cancel: nil,
                                                   origin: view)

        let doneButton = UIBarButtonItem(title: R.string.localization.decide.localized(),
                                         style: .done,
                                         target: nil,
                                         action: nil)
        let cancelButton = UIBarButtonItem(title: R.string.localization.buttonCancelTitle.localized(),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
        let pickerBackgroundColor = ColorName.cD1D4D9.color
        let toolbarBackgroundColor = ColorName.white.color

        self.stringPicker = stringPicker?.then {
            $0.setDoneButton(doneButton)
            $0.setCancelButton(cancelButton)
            $0.pickerBackgroundColor = pickerBackgroundColor
            $0.toolbarBackgroundColor = toolbarBackgroundColor
        }
    }

    private func configDatePicker(at view: UIView, initialSelection: Date) {
        let doneAction: ActionDateDoneBlock = { [weak self] picker, value, _ in
            guard let weakSelf = self else {
                return
            }

            guard let value = value as? Date else {
                return
            }

            weakSelf.updateDate(value, at: view)
        }

        let datePicker = ActionSheetDatePicker(title: TSConstants.EMPTY_STRING,
                                                 datePickerMode: .date,
                                                 selectedDate: initialSelection,
                                                 doneBlock: doneAction,
                                                 cancel: nil,
                                                 origin: view)
        let doneButton = UIBarButtonItem(title: R.string.localization.decide.localized(),
                                         style: .done,
                                         target: nil,
                                         action: nil)
        let cancelButton = UIBarButtonItem(title: R.string.localization.buttonCancelTitle.localized(),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
        let pickerBackgroundColor = ColorName.cD1D4D9.color
        let toolbarBackgroundColor = ColorName.white.color

        self.datePicker = datePicker?.then {
            $0.maximumDate = Date()
            $0.setDoneButton(doneButton)
            $0.setCancelButton(cancelButton)
            $0.pickerBackgroundColor = pickerBackgroundColor
            $0.toolbarBackgroundColor = toolbarBackgroundColor
        }
    }

    func displayUserInfo() {
        let userDetail = basePresenter.tempUserDetail

        _ = fullNameCell.then {
            $0.leftTextField.text = userDetail.last_name
            $0.rightTextField.text = userDetail.first_name
        }

        _ = fullNameKanaCell.then {
            $0.leftTextField.text = userDetail.last_furigana
            $0.rightTextField.text = userDetail.first_furigana
        }

        displayGender()
        displayBirthday()

        _ = phoneNumberCell.then {
            $0.leftTextField.text = userDetail.tel_no
        }

        displayUserAddress()
    }

    func displayUserAddress() {
        let userDetail = basePresenter.tempUserDetail

        _ = zipcodeCell.then {
            $0.leftTextField.text = userDetail.zipcode
        }

        displayPrefecture()

        _ = cityCell.then {
            $0.leftTextField.text = userDetail.city
        }

        _ = addressCell.then {
            $0.leftTextField.text = userDetail.address
        }

        _ = buildingCell.then {
            $0.leftTextField.text = userDetail.building
        }
    }

    private func displayGender() {
        genderCell.configCellWithData(data: basePresenter.getGenders())
    }

    private func displayBirthday() {
        let userDetail = basePresenter.tempUserDetail

        _ = birthdayCell.then {
            $0.leftTextField.text = userDetail.birthdayForDisplaying
        }
    }

    private func displayPrefecture() {
        prefectureCell.configCellWithData(data: basePresenter.getPrefectures())
    }

    private func updateValue(_ value: String, row: Int, at view: UIView) {
        if view == genderCell {
            switch row {
            case 1:
                basePresenter.tempUserDetail.gender = .female
            case 2:
                basePresenter.tempUserDetail.gender = .male
            default:
                basePresenter.tempUserDetail.gender = .unknown
            }
//            basePresenter.tempUserDetail.gender = Gender(raw: row.toString())
            displayGender()
        } else if view == prefectureCell {
            basePresenter.tempUserDetail.prefecture = row
            displayPrefecture()
        }
    }

    private func updateDate(_ date: Date, at view: UIView) {
        if view == birthdayCell {
            basePresenter.tempUserDetail.birthdayInDate = date
            displayBirthday()
        }
    }

    @objc func indexPathForFirstErrorCell() -> IndexPath? {
        var indexPath: IndexPath?
        if basePresenter.verifyFullNameMessage() != nil {
            indexPath = indexPathForStaticCells[fullNameCell]
        } else if basePresenter.verifyFullNameKanaMessage() != nil {
            indexPath = indexPathForStaticCells[fullNameKanaCell]
        } else if basePresenter.verifyGenderMessage() != nil {
            indexPath = indexPathForStaticCells[genderCell]
        } else if basePresenter.verifyBirthdayMessage() != nil {
            indexPath = indexPathForStaticCells[birthdayCell]
        } else if basePresenter.verifyPhoneMessage() != nil {
            indexPath = indexPathForStaticCells[phoneNumberCell]
        } else if basePresenter.verifyZipcodeMessage() != nil {
            indexPath = indexPathForStaticCells[zipcodeCell]
        } else if basePresenter.verifyPrefectureMessage() != nil {
            indexPath = indexPathForStaticCells[prefectureCell]
        } else if basePresenter.verifyCityMessage() != nil {
            indexPath = indexPathForStaticCells[cityCell]
        } else if basePresenter.verifyAddressMessage() != nil {
            indexPath = indexPathForStaticCells[addressCell]
        }
//        else if basePresenter.verifyBuildingMessage() != nil {
//           indexPath = indexPathForStaticCells[buildingCell]
//        }

        return indexPath
    }

    private func scrollToErrorCell() {
        let indexPath = indexPathForFirstErrorCell()
        guard let uwIndexPath = indexPath else {
            return
        }

        tableView.scrollToRow(at: uwIndexPath, at: .top, animated: true)
    }

    func displayErrorOnInputIfNeed() {
        configErrorForCells()
        tableView.reloadData()
        scrollToErrorCell()
    }

    private func showDatePickerForBirthdaySelection() {
        let defaultDate = yyyyMMddWithSlashFormatter.date(from: "1960/01/01") ?? Date()
        let initialSelection = basePresenter.tempUserDetail.birthdayInDate ?? defaultDate
        configDatePicker(at: birthdayCell, initialSelection: initialSelection)
        datePicker?.show()
    }
}

extension PersonalInfoTableViewController {

    private func verifyZipcode(_ zipcode: String) -> String? {
        let zipcode = zipcode.trim()
        guard zipcode.count >= NumberConstant.zipcodeLength else {
            return R.string.localization.thePostalCodeMustBeXCharacters.localized(
                [NumberConstant.zipcodeLength.toString()]
            )
        }

        return nil
    }

    func didTapSearchZipcode(_ zipcode: String) {
        if let verifyZipcodeMessage = verifyZipcode(zipcode) {
            _ = rx_alertWithMessage(message: verifyZipcodeMessage).subscribe()
            return
        }

        basePresenter.search(zipcode: zipcode)
    }

    @objc func didTapTermButton() {
        baseRouter.openTerms(
            url: URL(string: "http://app.merry.inc/app/subscription_notes/"),
            title: R.string.localization.notesOnSubscription2.localized()
        )
    }

    @objc func didTapAgreeButton() {
        displayErrorOnInputIfNeed()

        if basePresenter.verifyUserInfoMessage() != nil {
            return
        }

        basePresenter.updateUser()
    }
}

// MARK: - UITableViewDataSource

extension PersonalInfoTableViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        indexPathForStaticCells[cell] = indexPath

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PersonalInfoTableViewController {

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate

extension PersonalInfoTableViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentString: NSString = (textField.text ?? TSConstants.EMPTY_STRING) as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

        // Verify number
        let isNumberField = (textField == phoneNumberCell.leftTextField
            || textField == zipcodeCell.leftTextField)
        if isNumberField
            && newString.length > 0 {
            let disallowedCharacterSet = CharacterSet.decimalDigits.inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil

            guard replacementStringIsLegal else {
                return replacementStringIsLegal
            }
        }

        // Verify max length
        let isNameField = (textField == fullNameCell.leftTextField
            || textField == fullNameCell.rightTextField
            || textField == fullNameKanaCell.leftTextField
            || textField == fullNameKanaCell.rightTextField)
        if isNameField {
            return newString.length <= NumberConstant.nameLength
        } else if textField == phoneNumberCell.leftTextField {
            return newString.length <= NumberConstant.phoneLength
        } else if textField == zipcodeCell.leftTextField {
            return newString.length <= NumberConstant.zipcodeMaxLength
        } else if textField == cityCell.leftTextField {
            return newString.length <= NumberConstant.addressLength
        } else if textField == addressCell.leftTextField {
            return newString.length <= NumberConstant.addressLength
        } else if textField == buildingCell.leftTextField {
           return newString.length <= NumberConstant.buildingLength
       }

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdayCell.leftTextField {
            view.endEditing(true)
            showDatePickerForBirthdaySelection()

            return false
        }

        return true
    }
}

// MARK: - DropdownTableViewCellDelegate

extension PersonalInfoTableViewController: DropdownTableViewCellDelegate {

    func openDropDown(from cell: DropdownTableViewCell) {
        view.endEditing(true)

        if cell == genderCell {
            let (initialSelection, _, genders) = basePresenter.getGenders()
            configStringPicker(at: cell,
                               initialSelection: initialSelection ?? 0,
                               data: genders)
        } else if cell == prefectureCell {
            let (initialSelection, _, prefectures) = basePresenter.getPrefectures()
            configStringPicker(at: cell,
                               initialSelection: initialSelection ?? 0,
                               data: prefectures)
        }

        stringPicker?.show()
    }
}

// MARK: - UserInfoViewDelegate

extension PersonalInfoTableViewController: UserInfoViewDelegate {

    func didSearchZipcodeInfo() {
        displayUserAddress()
    }

    @objc func didGetUserInfo() {
        displayUserInfo()
    }

    @objc func didUpdateUserInfo() {

    }
}
