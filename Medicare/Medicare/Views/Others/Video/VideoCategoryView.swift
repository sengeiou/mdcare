//
//  VideoCategoryView.swift
//  Medicare
//
//  Created by Thuan on 4/1/20.
//

import Foundation

struct CategoryItem {
    var title = ""
}

final class VideoCategoryView: UIView {

    // MARK: IBOutlets

    @IBOutlet weak var colView: UICollectionView!

    // MARK: Variables

    fileprivate var categoryItems = [CategoryItem]()

    override func awakeFromNib() {
        super.awakeFromNib()

        configCollectionView()
    }

    fileprivate func configCollectionView() {
        _ = colView.then {
            $0.register(UINib(nibName: R.nib.categoryCollectionViewCell.name, bundle: nil),
                        forCellWithReuseIdentifier: R.reuseIdentifier.categoryCollectionViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
        }
    }

    func reloadData(_ items: [CategoryItem]) {
        categoryItems = items
        colView.reloadData()
    }
}

extension VideoCategoryView: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iden = R.reuseIdentifier.categoryCollectionViewCellID.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden, for: indexPath)
        if let cell = cell as? CategoryCollectionViewCell {
            cell.lbCategory.text = categoryItems[indexPath.row].title
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sizeLabel(categoryItems[indexPath.row].title)
        return CGSize(width: size.width, height: 22)
    }
}
