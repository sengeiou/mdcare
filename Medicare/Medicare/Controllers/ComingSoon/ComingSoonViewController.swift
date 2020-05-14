//
//  ComingSoonViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit

class ComingSoonViewController: BasePagerViewController {

    // MARK: - Variable

    fileprivate let comingSoonLabel = UILabel()

    // MARK: - Initialize

    class func newTempInstance() -> ComingSoonViewController {
        let newInstance = ComingSoonViewController()

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ComingSoonViewController {

    override func configView() {
        super.configView()

        configComingSoonLabel()
    }

    func configComingSoonLabel() {
        _ = comingSoonLabel.then {
            $0.font = .medium(size: 18.0)
            $0.textColor = ColorName.c333333.color
            $0.textAlignment = .center
            $0.text = "Coming soon"
        }

        view.addSubview(comingSoonLabel)
        view.addConstraints(withFormat: "H:|[v0]|", views: comingSoonLabel)
        view.addConstraints(withFormat: "V:|[v0]|", views: comingSoonLabel)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }
}
