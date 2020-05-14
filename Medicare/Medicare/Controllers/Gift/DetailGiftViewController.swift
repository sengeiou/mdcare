//
//  DetailGiftViewController.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import UIKit
import Kingfisher

private let cellIdentifier = R.reuseIdentifier.detailGiftSupplementaryTableViewCellID.identifier

final class DetailGiftViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet weak var tblView: UITableView!

    // MARK: Variables

    var route: DetailGiftRouter?
    var gift: GiftModel?
    fileprivate var supplementaryItems = [GiftSupplementaryModel]()
    fileprivate var p: DetailGiftPresenter?

    // MARK: - Initialize

    class func newInstance() -> DetailGiftViewController {
        guard let newInstance = R.storyboard.gift.detailGiftViewController() else {
             fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func actionBack() {
        route?.close()
    }
}

extension DetailGiftViewController {

    override func configView() {
        super.configView()

        configTableView()

        p = DetailGiftPresenter()
        p?.delegate = self
        getDetail()
    }

    fileprivate func configTableView() {
        _ = tblView.then {
            $0.delegate = self
            $0.dataSource = self
            $0.estimatedRowHeight = 100
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedSectionHeaderHeight = 100
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedSectionFooterHeight = 100
            $0.sectionFooterHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            $0.separatorColor = UIColor.clear
            $0.register(UINib(nibName: R.nib.detailGiftSupplementaryTableViewCell.name, bundle: nil),
                        forCellReuseIdentifier: cellIdentifier)
        }
        extendBottomInsetIfNeed(for: tblView)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle(gift?.title ?? "")

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    fileprivate func getDetail() {
        guard let gift = gift else {
            return
        }

        p?.getDetail(gift.id)
    }

    private func verifyPresentApplication() {
        weak var weakSelf = self
        func verifyGiftStatus() {
            guard let weakSelf = weakSelf else {
                return
            }

            guard let gift = weakSelf.gift else {
                    return
            }

            let giftStatus = DetailGiftPresenter.getStatusOf(gift: gift)
            switch giftStatus {
            case .alreadyApplicant:
                presentAlreadyApplicantWarning()
            case .pointNotEnough:
                weakSelf.displayPointNotEnoughWarning()
            case .availability:
                weakSelf.applicantPresent()
            case .requiredInfo:
                weakSelf.openPresentApplication()
            }
        }

        p?.getUserInfo(success: {
            verifyGiftStatus()
        })
    }

    private func openPresentApplication() {
        guard let gift = gift else {
            return
        }

        let giftId = gift.id
        let giftTitle = gift.title
        let questions = p?.cloneQuestionsFrom(gift.present_question)
        route?.openPresentApplication(
            id: giftId,
            presentTitle: giftTitle,
            questions: questions
        )
    }

    private func presentAlreadyApplicantWarning() {
        presentCustomAlertWith(
            title: nil,
            image: R.image.failIconAlert(),
            message: "このプレゼントは\n応募済みです。", // R.string.localization.applicantFailed.localized(),
            okButtonTitle: R.string.localization.close.localized())
    }

    private func displayPointNotEnoughWarning() {
        presentCustomAlertWith(
            title: nil,
            image: R.image.failIconAlert(),
            message: R.string.localization.notEnoughPoints.localized(),
            okButtonTitle: R.string.localization.close.localized())
    }

    private func applicantPresent() {
        guard let gift = gift else {
            return
        }

        let giftId = gift.id

        p?.applicantPresent(giftId)
    }
}

extension DetailGiftViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplementaryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as? TSBaseTableViewCell else {
                                                            return UITableViewCell()
                                                        }
        cell.configCellWithData(data: supplementaryItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.detailGiftViewHeaderView.firstView(owner: nil)
        header?.setData(gift)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = R.nib.detailGiftViewFooterView.firstView(owner: nil)
        footer?.setData(gift)
        footer?.presentApply = { [weak self] in
            guard let weakSelf = self else {
                return
            }

            weakSelf.verifyPresentApplication()
        }
        return footer
    }
}

extension DetailGiftViewController: DetailGiftPresenterDelegate {

    func getDetailCompleted(gift: GiftModel?, supplementaryItems: [GiftSupplementaryModel]) {
        self.gift = gift
        self.supplementaryItems = supplementaryItems
        tblView.reloadData()
    }

    func didApplicantPresent(_ message: String?) {
        if message != nil {
            return
        }

        route?.openPresentApplicationDone()
    }
}
