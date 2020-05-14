//
//  DataTransferViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class DataTransferViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var passwordGenerationButton: CommonButton!
    @IBOutlet fileprivate weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variable

    fileprivate let presenter = DataTransferPresenter()
    fileprivate var router = DataTransferRouter()

    // MARK: - Initialize

    class func newInstance() -> DataTransferViewController {
        guard let newInstance = R.storyboard.myMenu.dataTransferViewController() else {
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

    func set(router: DataTransferRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadNotes()
    }
}

extension DataTransferViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configViews()
        configTextView()
        configPasswordGenerationButton()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.dataTransfer.localized()
        passwordGenerationButton.setTitle(R.string.localization.issuePassword.localized(), for: .normal)

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
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

    private func configPasswordGenerationButton() {
        _ = passwordGenerationButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapPasswordGenerationButton()
                })
        }
    }
}

// MARK: - Actions

extension DataTransferViewController {

    private func didTapPasswordGenerationButton() {
        router.openPasswordGeneration()
    }

    override func actionBack() {
        router.close()
    }
}

// MARK: - DataTransferViewDelegate

extension DataTransferViewController: DataTransferViewDelegate {

    func didLoadGuides() {
        textView.attributedText = presenter.guidesHtml
    }
}
