//
//  DetailNotificationViewController.swift
//  Medicare
//
//  Created by Thuan on 3/11/20.
//

import UIKit
import Kingfisher

final class DetailNotificationViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var lbTime: UILabel!
    @IBOutlet fileprivate weak var lbContent: UILabel!
    @IBOutlet fileprivate weak var btnContinue: CommonButton!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: Variables

    var route: DetailNotificationRouter?
    var information: NotificationModel?

    // MARK: - Initialize

    class func newInstance() -> DetailNotificationViewController {
        guard let newInstance = R.storyboard.notification.detailNotificationViewController() else {
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

extension DetailNotificationViewController {

    override func configView() {
        super.configView()

        configScrollView()
        configLabels()
        configButtons()
        setData()
    }

    fileprivate func configScrollView() {
        _ = scrollView.then {
            $0.delegate = self
        }
        extendBottomInsetIfNeed(for: scrollView)
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 18)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbTime.then {
            $0.font = .regular(size: 14)
            $0.textColor = ColorName.c333333.color
        }

        _ = lbContent.then {
            $0.font = .regular(size: 16)
            $0.textColor = ColorName.c333333.color
        }
    }

    fileprivate func configButtons() {
        _ = btnContinue.then {
            $0.setTitle("その他のお知らせを見る", for: .normal)
        }

        _ = btnContinue.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    self?.openOtherNotify()
                })
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    fileprivate func openOtherNotify() {
        if let controllersInStack = navigationController?.viewControllers,
            controllersInStack.first(where: { $0 is NotificationListViewController }) != nil {
            route?.close()
            return
        }
        route?.openNotificationListView()
    }
}

extension DetailNotificationViewController {

    fileprivate func setData() {
        guard  let info = information else {
            return
        }

        setTitle(info.title ?? "")
        lbTitle.text = info.title
        lbTime.text = info.time
        lbContent.setHTMLFromString(htmlText: info.content ?? "")
    }
}
