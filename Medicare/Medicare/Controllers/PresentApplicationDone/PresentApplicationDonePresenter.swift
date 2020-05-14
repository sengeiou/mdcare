//
//  PresentApplicationDonePresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

private let contentNeedReplace = "ContentNeedReplace"

protocol PresentApplicationDoneViewDelegate: class {
    func didLoadGuides()
}

final class PresentApplicationDonePresenter {

    fileprivate weak var delegate: PresentApplicationDoneViewDelegate?

    private(set) var guidesHtml = NSMutableAttributedString()

    convenience init(delegate: PresentApplicationDoneViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: PresentApplicationDoneViewDelegate) {
        self.delegate = delegate
    }
}

extension PresentApplicationDonePresenter {

    func loadInstructionText() {
        showHUDAndAllowUserInteractionEnabled()
        let type = ConfigType.appInstructionText.rawValue
        let key = ConfigKey.presentApplicationSuccessful.rawValue
        let gateWay = ConfigGateway()
        gateWay.getConfig(type: type,
                          key: key,
                          success: { [weak self] (response) in
                            if let json = response as? JSON {
                                let dataArr = Mapper<ConfigDataModel>().mapArray(JSONString:
                                    json["data"].rawString() ?? "")
                                let data = dataArr?.first(where: { $0.type == type
                                    && $0.key == key
                                    && $0.os == ConfigOS.iOS.rawValue })
                                self?.loadNotes(data?.value ?? "")
                            }
        }, failure: { [weak self] (_) in
            self?.loadNotes("")
        })
    }

    func loadNotes(_ text: String) {
        guard let url = R.file.presentApplicationDoneHtml() else {
            popHUDActivity()
            return
        }

//        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue(label: "", qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }

            let guidesHtmlData = (try? Data(contentsOf: url, options: .alwaysMapped)) ?? Data()
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            weakSelf.guidesHtml = (try? NSMutableAttributedString(data: guidesHtmlData,
                                                          options: options,
                                                          documentAttributes: nil)) ?? NSMutableAttributedString()
            let range = weakSelf.guidesHtml.mutableString.range(of: contentNeedReplace)
            weakSelf.guidesHtml.replaceCharacters(in: range, with: text)

            DispatchQueue.main.async {
                popHUDActivity()
                weakSelf.delegate?.didLoadGuides()
            }
        }
    }
}
