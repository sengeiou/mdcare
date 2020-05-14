//
//  WellnessTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

protocol WellnessTableViewCellDelegate: class {
    func openItemAt(indexPath: IndexPath)
}

final class WellnessTableViewCell: ShadowTableViewCell {

    fileprivate let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    fileprivate weak var presenter: WellnessPresenter?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        contentView.backgroundColor = ColorName.white.color
        selectionStyle = .none
        configCollectionView()
    }

    private func configCollectionView() {
        _ = collectionView.then {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }

        _ = collectionView.then {
            $0.register(WellnessCollectionViewCell.self,
                        forCellWithReuseIdentifier: WellnessCollectionViewCell.identifier)
        }

        let padding: CGFloat = 12
        let spacing: CGFloat = 8
        let itemWidth: CGFloat = 255
        let itemSize = CGSize(width: itemWidth, height: 190)
        _ = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.then {
            $0.scrollDirection = .horizontal
            $0.itemSize = itemSize
            $0.minimumInteritemSpacing = padding
            $0.minimumLineSpacing = spacing
            $0.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }

        let height = itemSize.height + 2*padding
        contentView.addSubview(collectionView)
        contentView.addConstraints(withFormat: "H:|-0-[v0]-0-|", views: collectionView)
        contentView.addConstraints(withFormat: "V:|[v0(\(height))]|", views: collectionView)
    }

    private func reloadData() {
        collectionView.reloadData()
    }

    private var sectionInUpperLevel: Int {
        let sectionInUpperLevel = indexPath?.section ?? 0

        return sectionInUpperLevel
    }

    override func setIndexPath(indexPath: IndexPath?, sender: AnyObject?) {
        super.setIndexPath(indexPath: indexPath, sender: sender)

        if collectionView.dataSource == nil {
            collectionView.dataSource = self
        }

        if collectionView.delegate == nil {
            collectionView.delegate = self
        }
    }
}

extension WellnessTableViewCell {

    override func configCellWithData(data: Any?) {
        presenter = data as? WellnessPresenter
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension WellnessTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfRowsAt(section: sectionInUpperLevel) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WellnessCollectionViewCell.identifier,
                                                            for: indexPath) as? WellnessCollectionViewCell else {
                                                                fatalError()
        }

        let newIndexPath = IndexPath(
            row: indexPath.row,
            section: sectionInUpperLevel
        )
        cell.configCellWithData(data: presenter?.mediaAt(indexPath: newIndexPath))
        cell.isVisiblePlayIcon = presenter?.shouldShowPlayIconAt(section: newIndexPath.section) ?? false

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension WellnessTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newIndexPath = IndexPath(
            row: indexPath.row,
            section: sectionInUpperLevel
        )
        (delegate as? WellnessTableViewCellDelegate)?.openItemAt(indexPath: newIndexPath)
    }
}
