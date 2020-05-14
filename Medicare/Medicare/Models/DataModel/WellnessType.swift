//
//  WellnessType.swift
//  Medicare
//
//  Created by sanghv on 4/6/20.
//

import Foundation

enum WellnessType: String {
    case none, magazine, video, present
}

extension WellnessType {

    var image: UIImage? {
        switch self {
        case .magazine:
            return R.image.magazine_tab_icon()
        case .video:
            return R.image.video_tab_icon()
        case .present:
            return R.image.gift_tab_icon()
        default:
            return nil
        }
    }
}
