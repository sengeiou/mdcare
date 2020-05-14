//
//  AnswerInputTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class AnswerInputTableViewCell: TSBaseTableViewCell {

    fileprivate let inputTextView = UITextView()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            inputTextView
        ])

        return stackView
    }()

    fileprivate weak var answer: AnswerModel?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        accessoryType = .none
        selectionStyle = .none
        configStackView()
        configInputTextView()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-0-[v0]-0-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-4@750-[v0(100)]-4-|", views: stackView)
    }

    private func configInputTextView() {
        _ = inputTextView.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 16.0)
            $0.borderColor = ColorName.cCCCCCC.color
            $0.borderWidth = 1.0
            $0.cornerRadius = 8.0

            _ = $0.rx.text.orEmpty
                .takeUntil($0.rx.deallocated)
                .subscribe(onNext: { [weak self] (text) in
                    guard let wealSelf = self else {
                        return
                    }

                    wealSelf.updateInputAnswer(text)
                })
        }
    }
}

extension AnswerInputTableViewCell {

    private func updateInputAnswer(_ text: String) {
        answer?.present_question_content = text
    }
}

extension AnswerInputTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let (inputText, _) = data as? (String, Bool) else {
            return
        }

        inputTextView.text = inputText
    }

    func setAnswer(_ answer: AnswerModel) {
        self.answer = answer
    }
}
