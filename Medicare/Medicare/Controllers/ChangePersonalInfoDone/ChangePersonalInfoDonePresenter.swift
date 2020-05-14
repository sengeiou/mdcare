//
//  ChangePersonalInfoDonePresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol ChangePersonalInfoDoneViewDelegate: class {
    func didLoadGuides()
}

final class ChangePersonalInfoDonePresenter {

    fileprivate weak var delegate: ChangePersonalInfoDoneViewDelegate?

    private(set) var guidesHtml = NSAttributedString()

    convenience init(delegate: ChangePersonalInfoDoneViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: ChangePersonalInfoDoneViewDelegate) {
        self.delegate = delegate
    }
}

extension ChangePersonalInfoDonePresenter {

    func loadNotes() {
        guard let url = R.file.changePersonalInfoDoneHtml() else {
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
