//
//  ChangePersonalInfoDoneViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class ChangePersonalInfoDoneViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var backToHomeButton: CommonButton!
    @IBOutlet fileprivate weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variable

    fileprivate let presenter = ChangePersonalInfoDonePresenter()
    fileprivate var router = ChangePersonalInfoDoneRouter()

    // MARK: - Initialize

    class func newInstance() -> ChangePersonalInfoDoneViewController {
        guard let newInstance = R.storyboard.myMenu.changePersonalInfoDoneViewController() else {
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

    func set(router: ChangePersonalInfoDoneRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadNotes()
    }
}

extension ChangePersonalInfoDoneViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configViews()
        configTextView()
        configBackToHomeButton()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.buttonDoneTitle.localized()
        backToHomeButton.setTitle(R.string.localization.backToHome.localized(), for: .normal)

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

extension ChangePersonalInfoDoneViewController {

    private func didTapBackToHomeButton() {
//        router.closeToRoot()
        super.actionOpenHome()
    }

    override func actionBack() {
        router.close()
    }
}

// MARK: - ChangePersonalInfoDoneViewDelegate

extension ChangePersonalInfoDoneViewController: ChangePersonalInfoDoneViewDelegate {

    func didLoadGuides() {
        textView.attributedText = presenter.guidesHtml
    }
}
