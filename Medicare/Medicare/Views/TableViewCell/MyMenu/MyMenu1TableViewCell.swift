//
//  MyMenu1TableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

protocol MyMenu1TableViewCellDelegate: class {
    func openItem(_ item: MyMenuRow1)
}

final class MyMenu1TableViewCell: ShadowTableViewCell {

    fileprivate let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    fileprivate let presenter = MyMenuPresenter()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        selectionStyle = .none
        configCollectionView()
    }

    private func configCollectionView() {
        _ = collectionView.then {
            $0.backgroundColor = ColorName.cDFDFDF.color
            $0.dataSource = self
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
            // $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }

        _ = collectionView.then {
            $0.register(MyMenu1CollectionViewCell.self,
                        forCellWithReuseIdentifier: MyMenu1CollectionViewCell.identifier)
        }

        let padding: CGFloat = 0.0
        let spacing: CGFloat = 1.0
        let numberOfRows: CGFloat = 2
        let itemWidth = (screenWidth - 2*padding - (numberOfRows - 1)*spacing) / numberOfRows
        let itemSize = CGSize(width: itemWidth, height: 103)
        _ = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.then {
            $0.scrollDirection = .vertical
            $0.itemSize = itemSize
            $0.minimumInteritemSpacing = spacing
            $0.minimumLineSpacing = spacing
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        let height = itemSize.height * numberOfRows + (numberOfRows - 1) * spacing
        contentView.addSubview(collectionView)
        contentView.addConstraints(withFormat: "H:|-\(padding)-[v0]-\(padding)-|", views: collectionView)
        contentView.addConstraints(withFormat: "V:|-0-[v0(\(height))]-0-|", views: collectionView)
    }

    private func reloadData() {
        collectionView.reloadData()
    }
}

extension MyMenu1TableViewCell {

    override func configCellWithData(data: Any?) {
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension MyMenu1TableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInMenu1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMenu1CollectionViewCell.identifier,
                                                            for: indexPath) as? TSBaseCollectionViewCell else {
                                                                fatalError()
        }

        cell.configCellWithData(data: presenter.itemInMenu1At(row: indexPath.row))

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MyMenu1TableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = presenter.itemInMenu1At(row: indexPath.row)
        (delegate as? MyMenu1TableViewCellDelegate)?.openItem(menuItem)
    }
}
