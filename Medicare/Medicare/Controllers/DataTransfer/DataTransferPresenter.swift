//
//  DataTransferPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol DataTransferViewDelegate: class {
    func didLoadGuides()
}

final class DataTransferPresenter {

    fileprivate weak var delegate: DataTransferViewDelegate?

    private(set) var guidesHtml = NSAttributedString()

    convenience init(delegate: DataTransferViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: DataTransferViewDelegate) {
        self.delegate = delegate
    }
}

extension DataTransferPresenter {

    func loadNotes() {
        guard let url = R.file.dataTransferGuidesHtml() else {
            return
        }

        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue(label: "", qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }

            let guidesHtmlData = (try? Data(contentsOf: url, options: .alwaysMapped)) ?? Data()
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            weakSelf.guidesHtml = (try? NSAttributedString(data: guidesHtmlData,
                                                          options: options,
                                                          documentAttributes: nil)) ?? NSAttributedString()

            DispatchQueue.main.async {
                popHUDActivity()
                weakSelf.delegate?.didLoadGuides()
            }
        }
    }
}
