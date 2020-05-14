//
//  PersonalInfoSummaryTableViewController.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

class PersonalInfoSummaryTableViewController: BaseTableViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var nameValueCell: TextValueTableViewCell!
    @IBOutlet weak var nameKanaValueCell: TextValueTableViewCell!
    @IBOutlet weak var genderValueCell: TextValueTableViewCell!
    @IBOutlet weak var birthdayValueCell: TextValueTableViewCell!
    @IBOutlet weak var phoneValueCell: TextValueTableViewCell!
    @IBOutlet weak var addressValueCell: TextValueTableViewCell!

    lazy var userInfoCells: [TSBaseTableViewCell] = {
        return [
            nameValueCell,
            nameKanaValueCell,
            genderValueCell,
            birthdayValueCell,
            phoneValueCell,
            addressValueCell
        ]
    }()

    // MARK: - Variable

    var basePresenter: UserInfoPresenter {
        return UserInfoPresenter()
    }
    var updateMagazineSubscription = false

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func set(userDetail: UserDetailModel) {
        basePresenter.setTempUserDetail(userDetail)
    }

    func loadData() {

    }
}

extension PersonalInfoSummaryTableViewController {

    override func configView() {
        super.configView()

        basePresenter.set(delegate: self)
        configTableView()
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
        _ = nameValueCell.then {
            $0.titleLabel.text = R.string.localization.fullname.localized()
        }

        _ = nameKanaValueCell.then {
            $0.titleLabel.text = R.string.localization.nameKana.localized()
        }

        _ = genderValueCell.then {
            $0.titleLabel.text = R.string.localization.gender.localized()
        }

        _ = birthdayValueCell.then {
            $0.titleLabel.text = R.string.localization.birthday.localized()
        }

        _ = phoneValueCell.then {
            $0.titleLabel.text = R.string.localization.phoneNumber.localized()
        }

        _ = addressValueCell.then {
            $0.titleLabel.text = R.string.localization.streetAddress.localized()
        }

        displayUserInfo()
    }

    private func displayUserInfo() {
        let userDetail = basePresenter.tempUserDetail

        _ = nameValueCell.then {
            $0.valueLabel.text = userDetail.fullName
        }

        _ = nameKanaValueCell.then {
            $0.valueLabel.text = userDetail.fullNameKana
        }

        _ = genderValueCell.then {
            $0.valueLabel.text = userDetail.gender.title
        }

        _ = birthdayValueCell.then {
            $0.valueLabel.text = userDetail.birthdayForDisplaying
        }

        _ = phoneValueCell.then {
            $0.valueLabel.text = userDetail.tel_no
        }

        displayUserAddress()
    }

    private func displayUserAddress() {
        let userDetail = basePresenter.tempUserDetail

        _ = addressValueCell.then {
            $0.valueLabel.text = userDetail.fullAddress
        }
    }
}

// MARK: - UITableViewDelegate

extension PersonalInfoSummaryTableViewController {

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UserInfoViewDelegate

extension PersonalInfoSummaryTableViewController: UserInfoViewDelegate {

    @objc func didUpdateUserInfo() {

    }
}
