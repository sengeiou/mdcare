//
//  ContentVideoListPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation

protocol ContentVideoListPresenterDelegate: class {
    func loadVideosCompleted(_ videoItems: [VideoModel])
}

final class ContentVideoListPresenter {

    weak var delegate: ContentVideoListPresenterDelegate?

    func loadVideos() {
        let videos = [VideoModel]()

        delegate?.loadVideosCompleted(videos)
    }
}
