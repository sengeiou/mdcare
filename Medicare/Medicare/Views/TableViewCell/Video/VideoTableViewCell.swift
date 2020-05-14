//
//  VideoTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/9/20.
//

import UIKit
import Kingfisher

typealias VideoTableViewCellFavorite = (UITableViewCell?) -> Void
typealias VideoTableViewCellLike = (UITableViewCell?) -> Void

final class VideoTableViewCell: TSBaseTableViewCell {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var wrapperView: UIView!
    @IBOutlet fileprivate weak var thumbnail: UIImageView!
    @IBOutlet fileprivate weak var lbTitle: UILabel!
    @IBOutlet fileprivate weak var btnHeart: UIButton!
    @IBOutlet fileprivate weak var btnLike: UIButton!
    @IBOutlet fileprivate weak var playView: UIView!
    @IBOutlet fileprivate weak var rankingImageView: UIImageView!
    @IBOutlet fileprivate weak var rankingLabel: UILabel!
    @IBOutlet weak var colView: UICollectionView!

    // MARK: Variables

    var favorite: HomeMagazineTableViewCellFavorite?
    var like: HomeMagazineTableViewCellLike?
    fileprivate var categoryItems = [CategoryItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none
    }
}

extension VideoTableViewCell {

    override func configView() {
        super.configView()

        configLabels()
        configButtons()
        configWrapperView()
        configCollectionView()
        addActionForButtons()
    }

    fileprivate func configLabels() {
        _ = lbTitle.then {
            $0.font = .medium(size: 16)
            $0.textColor = ColorName.c333333.color
        }

        _ = rankingLabel.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.white.color
        }
    }

    fileprivate func configButtons() {
        _ = btnLike.then {
            $0.titleLabel?.font = .regular(size: 14)
            $0.setTitleColor(ColorName.c333333.color, for: .normal)
            $0.setImage(R.image.unlike_icon(), for: .normal)
            $0.setTitleColor(ColorName.c0092C4.color, for: .selected)
            $0.setImage(R.image.like_icon(), for: .selected)
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.backgroundColor = ColorName.cF9F9F9.color
            $0.layer.cornerRadius = 3
        }

        _ = btnHeart.then {
            $0.setImage(R.image.unfavourite_icon(), for: .normal)
            $0.setImage(R.image.favourite_icon(), for: .selected)
        }
    }

    fileprivate func configWrapperView() {
        _ = wrapperView.then {
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
            $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 2.0
            $0.layer.cornerRadius = 5
        }
    }

    fileprivate func configCollectionView() {
        _ = colView.then {
            $0.register(UINib(nibName: R.nib.categoryCollectionViewCell.name, bundle: nil),
                        forCellWithReuseIdentifier: R.reuseIdentifier.categoryCollectionViewCellID.identifier)
            $0.delegate = self
            $0.dataSource = self
        }
    }

    fileprivate func addActionForButtons() {
        _ = btnHeart.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.favorite?(weakSelf)
                })
        }

        _ = btnLike.then {
            // Add action
            _ = $0.rx.tap
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }

                    weakSelf.like?(weakSelf)
                })
        }
    }
}

extension VideoTableViewCell {

    override func configCellWithData(data: Any?) {
        if let video = data as? MagazineModel {
            setData(video)
            return
        }

        if let video = data as? VideoModel {
            setData(video)
            return
        }
    }

    private func setData(_ item: MagazineModel) {
        lbTitle.setSpacingText(item.title ?? "")
        btnLike.setTitle("\(item.good ?? 0)", for: .normal)
        thumbnail.kf.setImage(with: item.img_path)
        btnHeart.isSelected = item.isFavorited
        btnLike.isSelected = item.isLiked

        let rankValue = (indexPath?.row ?? 0) + 1
        rankingLabel.text = rankValue.toString()
        setRanking(rankValue)

        var categoryItems = [CategoryItem]()
        for category in item.category ?? [] {
            categoryItems.append(CategoryItem(title: category.name ?? ""))
        }
        showCategory(categoryItems)
    }

    private func setData(_ item: VideoModel) {
        lbTitle.setSpacingText(item.title ?? "")
        btnLike.setTitle("\(item.good ?? 0)", for: .normal)
        thumbnail.kf.setImage(with: item.img_path)
        btnHeart.isSelected = item.isFavorited
        btnLike.isSelected = item.isLiked

        let rankValue = (indexPath?.row ?? 0) + 1
        rankingLabel.text = rankValue.toString()
        setRanking(rankValue)

        var categoryItems = [CategoryItem]()
        for category in item.category ?? [] {
            categoryItems.append(CategoryItem(title: category.name ?? ""))
        }
        showCategory(categoryItems)
    }

    func setPlayingViewVisible(_ visible: Bool) {
        playView.isHidden = !visible
    }

    func setRankingVisible(_ visible: Bool) {
        rankingImageView.isHidden = !visible
        rankingLabel.isHidden = !visible
    }

    fileprivate func setRanking(_ rankValue: Int) {
        if rankValue == 1 {
            rankingImageView.image = R.image.ranking_top1()
        } else if rankValue == 2 {
            rankingImageView.image = R.image.ranking_top2()
        } else if rankValue == 3 {
            rankingImageView.image = R.image.ranking_top3()
        } else {
            rankingImageView.image = R.image.ranking_top4()
        }
    }

    fileprivate func showCategory(_ items: [CategoryItem]) {
        categoryItems = items
        colView.reloadData()
    }
}

extension VideoTableViewCell: UICollectionViewDelegate,
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
