//
//  CategorySettingViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

final class CategorySettingViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var registerButton: CommonButton!

    // MARK: - Variable

    fileprivate let presenter = CategorySettingPresenter()
    fileprivate var router = CategorySettingRouter()
    public var isRegistration = true
    public var isHiddenBack = true

    // MARK: - Initialize

    class func newInstance() -> CategorySettingViewController {
        guard let newInstance = R.storyboard.category.categorySettingViewController() else {
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

    func set(router: CategorySettingRouter) {
        self.router = router
    }

    private func loadData() {
        presenter.loadCategory()
        // presenter.loadTag()
    }
}

extension CategorySettingViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configShadowView()
        configCollectionView()
        observeCollectionViewContentSize()
        configRegisterButton()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        title = R.string.localization.categoryTagSetting.localized()
        registerButton.setTitle(R.string.localization.register.localized(), for: .normal)

        if !isHiddenBack {
            setNavigationBarButton(items: [
                (.back(title: R.string.localization.return.localized()), .left)
            ])
        } else {
            hidesBackButton()
        }
    }

    private func configShadowView() {
        _ = shadowView.then {
            $0.backgroundColor = ColorName.cF9F9F9.color
            // $0.cornerRadius = 10.0
            $0.dropShadowForContainer()
        }
    }

    private func configCollectionView() {
        _ = collectionView.then {
            $0.dataSource = self
            $0.delegate = self
            $0.showsVerticalScrollIndicator = false
            $0.allowsMultipleSelection = true
            // $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }
        extendBottomInsetIfNeed(for: collectionView)

        _ = collectionView.then {
            $0.register(TextOnlyCollectionReusableView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: TextOnlyCollectionReusableView.identifier)
            $0.register(CategorySettingCollectionFooterView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: CategorySettingCollectionFooterView.identifier)
            $0.register(TextOnlyCollectionViewCell.self,
                        forCellWithReuseIdentifier: TextOnlyCollectionViewCell.identifier)
        }

        let padding: CGFloat = 12.0
        let spacing: CGFloat = 8.0
        _ = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 15
            $0.minimumInteritemSpacing = spacing
            $0.headerReferenceSize = getCollectionViewHeaderSize()
            $0.itemSize = getCollectionViewItemSize(
                padding: padding,
                spacing: spacing
            )
            $0.sectionInset = UIEdgeInsets(
                top: 0,
                left: padding,
                bottom: 20,
                right: padding
            )
        }
    }

    private func observeCollectionViewContentSize() {
        _ = collectionView.rx.observe(CGSize.self, "contentSize")
            .takeUntil(collectionView.rx.deallocated)
            .subscribe(onNext: { [weak self] (size) in
                guard let size = size else {
                    return
                }

                guard let weakSelf = self else {
                    return
                }

                weakSelf.collectionViewConstraintHeight.constant = size.height
            })
    }

    private func getCollectionViewItemSize(padding: CGFloat, spacing: CGFloat) -> CGSize {
        let collectionViewOrigin = view.convert(collectionView.frame.origin,
                                               from: collectionView.superview)
        let numberOfItemsEachRow: CGFloat = 3
        let width =
            ((screenWidth - 2*collectionViewOrigin.x)
                - 2*padding
                - (numberOfItemsEachRow - 1)*spacing)/numberOfItemsEachRow
        let itemSize = CGSize(width: width.rounded(.down), height: 40)

        return itemSize
    }

    private func getCollectionViewHeaderSize(padding: CGFloat = 0.0) -> CGSize {
        let width =
            ((screenWidth - 2*collectionView.frame.minX)
                - 2*padding)
        let headerSize = CGSize(width: width, height: 60)

        return headerSize
    }

    private func updateCategorySelectedState() {
        let categorySection = CategorySettingSection.category.rawValue
        let numberOfCategories = collectionView.numberOfItems(
            inSection: categorySection
        )

        for row in 0..<numberOfCategories {
            let indexPath = IndexPath(row: row, section: categorySection)
            let isSelected = presenter.isSelectedAt(indexPath: indexPath)
            guard isSelected else {
                continue
            }

            collectionView.selectItem(at: indexPath,
                                      animated: true,
                                      scrollPosition: .init(rawValue: 0))
        }
    }

    private func configRegisterButton() {
        _ = registerButton.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.didTapActionButton()
                })
        }
    }
}

// MARK: - Actions

extension CategorySettingViewController {

    override func actionBack() {
        router.close()
    }
}

// MARK: - UICollectionViewDataSource

extension CategorySettingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsAt(section: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextOnlyCollectionViewCell.identifier,
                                                            for: indexPath) as? TSBaseCollectionViewCell else {
                                                                fatalError()
        }

        cell.configCellWithData(data: presenter.valueAt(indexPath: indexPath))

        return cell
    }

    func getSupplementaryViewReuseIdentifier(ofKind kind: String) -> String {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return TextOnlyCollectionReusableView.identifier
        case UICollectionView.elementKindSectionFooter:
            return CategorySettingCollectionFooterView.identifier
        default:
            return TSConstants.EMPTY_STRING
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let reuseIdentifier = getSupplementaryViewReuseIdentifier(ofKind: kind)
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                        withReuseIdentifier: reuseIdentifier,
                                                        for: indexPath) as? TSBaseCollectionReusableView else {
                                                            fatalError()
        }

        cell.setSection(section: indexPath.section, sender: self)
        cell.configHeaderWithData(data: presenter.sectionTitleAt(section: indexPath.section))

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategorySettingViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategorySettingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionType = CategorySettingSection(raw: section)
        switch sectionType {
        case .category:
            return .zero // CategorySettingCollectionFooterView.size
        case .tag:
            return .zero
        }
    }
}

// MARK: - CategorySettingCollectionFooterViewDelegate

extension CategorySettingViewController: CategorySettingCollectionFooterViewDelegate {

    func didTapActionButton() {
        let rows = collectionView.indexPathsForSelectedItems?.map { $0.row } ?? []
        guard !rows.isEmpty else {
            _ = rx_alertWithMessage(message: R.string.localization.pleaseSelectACategory.localized()).subscribe()
            return
        }

        presenter.updateSelectedCategoriesAt(rows: rows)
    }
}

// MARK: - CategorySettingViewDelegate

extension CategorySettingViewController: CategorySettingViewDelegate {

    func didLoadCategory() {
        collectionView.reloadData()
        updateCategorySelectedState()
    }

    func didLoadTag() {
        collectionView.reloadData()
    }

    func didUpdateCategory() {
        if isRegistration {
            TabBarController().setAsRootVCAnimated()
        } else {
            NotificationCenter.default.post(name:
                NSNotification.Name(StringConstant.categorySettingChangesNotification),
                                            object: nil,
                                            userInfo: nil)
            router.close()
        }
    }
}
