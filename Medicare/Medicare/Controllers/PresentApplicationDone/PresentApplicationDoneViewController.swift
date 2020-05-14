//
//  PresentApplicationDoneViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class PresentApplicationDoneViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var backToHomeButton: CommonButton!
    @IBOutlet fileprivate weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variable

    fileprivate let presenter = PresentApplicationDonePresenter()
    fileprivate var router = PresentApplicationDoneRouter()

    // MARK: - Initialize

    class func newInstance() -> PresentApplicationDoneViewController {
        guard let newInstance = R.storyboard.presentApplication.presentApplicationDoneViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    func set(router: PresentApplicationDoneRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadInstructionText()
    }
}

extension PresentApplicationDoneViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configViews()
        configTextView()
        configBackToHomeButton()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.applicationCompleted.localized()
        backToHomeButton.setTitle(R.string.localization.returnToTheGiftList.localized(), for: .normal)

        setNavigationBarButton(items: [
            (.home, .left),
            (.myPage, .right)
        ])
    }

    private func configViews() {
        _ = shadowView.then {
            $0.backgroundColor = ColorName.white.color
            // $0.cornerRadius = 10.0
            $0.dropShadowForContainer()
        }

        _ = scrollView.then {
            $0.showsVerticalScrollIndicator = false
            $0.cornerRadius = 10.0
            $0.masksToBounds = true
            $0.delegate = self
        }
        extendBottomInsetIfNeed(for: scrollView)
    }

    private func configTextView() {
        _ = textView.then {
            $0.showsVerticalScrollIndicator = false
            $0.isEditable = false
            $0.text = nil
        }

        _ = textView.rx.observe(CGSize.self, "contentSize")
            .takeUntil(textView.rx.deallocated)
            .subscribe(onNext: { [weak self] (size) in
                guard let size = size else {
                    return
                }

                guard let weakSelf = self else {
                    return
                }

                weakSelf.textViewHeightConstraint.constant = size.height
            })
    }

    private func configBackToHomeButton() {
        _ = backToHomeButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapBackToHomeButton()
                })
        }
    }
}

// MARK: - Actions

extension PresentApplicationDoneViewController {

    private func didTapBackToHomeButton() {
        tabBarController?.selectedIndex = TabBarItemType.present.rawValue
        // router.closeToRoot()
    }

    override func actionBack() {
        router.close()
    }
}

// MARK: - PresentApplicationDoneViewDelegate

extension PresentApplicationDoneViewController: PresentApplicationDoneViewDelegate {

    func didLoadGuides() {
        textView.attributedText = presenter.guidesHtml
    }
}
