//
//  QuestionTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class QuestionTableViewCell: TSBaseTableViewCell {

    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var requiredView: UIView!
    @IBOutlet fileprivate(set) weak var requiredLabel: UILabel!
    fileprivate let errorLabel = UILabel()
    @IBOutlet fileprivate(set) weak var tableView: WrapContentTableView!

    public var isRequired: Bool = true {
        didSet {
            requiredView.isHidden = !isRequired
        }
    }

    weak var presenter: PresentApplicationPresenter!
    public var isVisibleCheckBox: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configStackView()
        configRequiredView()
        configLabels()
        configTableView()
    }

    private func configStackView() {
        _ = stackView?.then {
            $0.spacing = 8.0
        }
    }

    private func configRequiredView() {
        _ = requiredView?.then {
            $0.backgroundColor = ColorName.cE84680.color
            $0.cornerRadius = $0.frame.height / 2
        }
    }

    private func configLabels() {
        _ = titleLabel.then {
            $0.textColor = ColorName.c333333.color
            $0.font = .medium(size: 18.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        _ = requiredLabel.then {
            $0.textColor = ColorName.white.color
            $0.font = .medium(size: 13.0)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
        }

        configErrorLabel()
    }

    private func configErrorLabel() {
        _ = errorLabel.then {
            $0.font = .medium(size: 14)
            $0.textColor = ColorName.cCC0D3F.color
            $0.numberOfLines = 2
            $0.text = nil
            $0.isHidden = true
        }

        stackView?.insertArrangedSubview(errorLabel, at: 1)
    }

    private func configTableView() {
        _ = tableView.then {
            $0.delegate = self
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.bounces = false
            $0.isScrollEnabled = true
            $0.estimatedSectionHeaderHeight = 80
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
            $0.sectionFooterHeight = 20.0
            $0.tableFooterView = UIView()
        }

        setTableViewDataSource()

        _ = tableView.then {
            $0.register(TitleOnlyTableViewHeaderView.self,
                        forHeaderFooterViewReuseIdentifier: TitleOnlyTableViewHeaderView.identifier)
            $0.register(AnswerCheckboxTableViewCell.self,
                        forCellReuseIdentifier: AnswerCheckboxTableViewCell.identifier)
            $0.register(AnswerInputTableViewCell.self,
                        forCellReuseIdentifier: AnswerInputTableViewCell.identifier)
        }
    }

    private func setTableViewDataSource() {
        if tableView.dataSource != nil {
            return
        }

        tableView.dataSource = self
    }
}

extension QuestionTableViewCell {

    override func configCellWithData(data: Any?) {
        tableView.reloadData()
    }

    func setError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message?.isEmpty ?? true
    }
}

// MARK: - UITableViewDataSource

extension QuestionTableViewCell: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfQuestions ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfAnswersAt(section: section)
    }

    private func getCellIdentifier(for section: Int) -> String {
        let questionType = presenter.questionTypeAt(section: section)
        switch questionType {
        case .input:
            return AnswerInputTableViewCell.identifier
        default:
            return AnswerCheckboxTableViewCell.identifier
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = getCellIdentifier(for: indexPath.section)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TSBaseTableViewCell else {
                                                        fatalError()
        }

        cell.setIndexPath(indexPath: indexPath, sender: self)
        cell.configCellWithData(data: presenter.answerContentAt(indexPath: indexPath))

        if let cell = cell as? AnswerCheckboxTableViewCell {
            cell.checkBoxGroup = presenter.checkBoxGroupAt(section: indexPath.section)
            cell.setAnswer(presenter.answerAt(indexPath: indexPath))
            cell.isVisibleCheckBox = isVisibleCheckBox
        } else if let cell = cell as? AnswerInputTableViewCell {
            cell.setAnswer(presenter.answerAt(indexPath: indexPath))
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension QuestionTableViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleOnlyTableViewHeaderView.identifier
        ) as? TitleOnlyTableViewHeaderView

        headerView?.contentView.backgroundColor = ColorName.white.color
        headerView?.configHeaderWithData(data: presenter.questionContentAt(section: section))
        headerView?.setHorirontalPadding(0.0)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
