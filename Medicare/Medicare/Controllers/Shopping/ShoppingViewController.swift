//
//  ShoppingViewController.swift
//  Medicare
//
//  Created by Thuan on 5/11/20.
//

import UIKit
import WebKit

private let productUrl = "https://merry.shop/products/list"
private let cartUrl = "https://merry.shop/cart"

private var basicAuth: String {
    let passwordString = "merry:Py72K4GB"
    let passwordData = passwordString.data(using: .utf8)
    let base64EncodedCredential = passwordData?.base64EncodedString(options: .lineLength64Characters)

    if let base64EncodedCredential = base64EncodedCredential {
        let authString = "Basic \(base64EncodedCredential)"
        return authString
    }

    return ""
}

final class ShoppingViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet weak var segmentTab: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!

    // MARK: Variables

    fileprivate let webView = WKWebView()

    // MARK: - Initialize

    class func newInstance() -> ShoppingViewController {
        guard let newInstance = R.storyboard.shopping.shoppingViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        dismissHUD()
        super.viewWillDisappear(animated)
    }
}

extension ShoppingViewController {

    override func configView() {
        super.configView()

        configWebView()
        configSegmentTab()
        loadData(productUrl)
    }

    private func configWebView() {
        _ = webView.then {
            $0.scrollView.showsVerticalScrollIndicator = false
            $0.scrollView.delegate = self
            $0.navigationDelegate = self
            $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }
        extendBottomInsetIfNeed(for: webView.scrollView)

        contentView.addSubview(webView)
        contentView.addConstraints(withFormat: "H:|-0-[v0]-0-|", views: webView)
        contentView.addConstraints(withFormat: "V:|-0-[v0]-0-|", views: webView)
    }

    private func configSegmentTab() {
        segmentTab.addTarget(self, action: #selector(didSelectTab(_:)), for: .valueChanged)

        segmentTab.tintColor = UIColor.clear
        segmentTab.backgroundColor = UIColor.clear
        if #available(iOS 13.0, *) {
            segmentTab.selectedSegmentTintColor = UIColor.clear
        }
        segmentTab.setTitleTextAttributes([.foregroundColor: UIColor.black,
                                           .font: UIFont.regular(size: 15)], for: .normal)
        segmentTab.setTitleTextAttributes([.foregroundColor: UIColor.black,
                                           .font: UIFont.bold(size: 15)], for: .selected)
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setTitle("ショッピング")

        setNavigationBarButton(items: [
            (.home, .left),
            (.myPage, .right)
        ])
    }

    private func loadData(_ url: String) {
        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue(label: "", qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }

            guard let url = URL(string: url) else {
                return
            }

            var request = URLRequest(url: url)
            request.setValue(basicAuth, forHTTPHeaderField: "Authorization")
            DispatchQueue.main.async {
                weakSelf.webView.load(request)
            }
        }
    }
}

extension ShoppingViewController {

    @objc fileprivate func didSelectTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadData(productUrl)
        default:
            loadData(cartUrl)
        }
    }
}

extension ShoppingViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        popHUDActivity()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        popHUDActivity()
    }
}
