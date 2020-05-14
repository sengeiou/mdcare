//
//  TermsViewController.swift
//  Medicare
//
//  Created by sanghv on 12/25/19.
//

import UIKit
import WebKit

final class TermsViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var shadowView: UIView!
    fileprivate let webView = WKWebView()

    // MARK: - Variable

    fileprivate let presenter = TermsPresenter()
    fileprivate var router = TermsRouter()
    public var url: URL?

    // MARK: - Initialize

    class func newInstance() -> TermsViewController {
        guard let newInstance = R.storyboard.myMenu.termsViewController() else {
            fatalError("Can't create new instance")
        }

        return newInstance
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        dismissHUD()

        super.viewWillDisappear(animated)
    }

    func set(router: TermsRouter) {
        self.router = router
    }

    private func loadData() {
        loadTerms()
    }

    private func loadTerms() {
        showHUDAndAllowUserInteractionEnabled()
        DispatchQueue(label: "", qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }

            guard let url = weakSelf.url, url.absoluteString != "about:blank" else {
                weakSelf.loadEmptyTerms()

                return
            }

            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                weakSelf.webView.load(request)
            }
        }
    }

    private func loadEmptyTerms() {
        guard let url = presenter.getEmptyTermUrl() else {
            return
        }

        DispatchQueue.main.async {
            self.webView.loadFileURL(url, allowingReadAccessTo: url)
        }

        return
    }
}

extension TermsViewController {

    override func configView() {
        super.configView()

        presenter.set(delegate: self)
        configShadowView()
        configWebView()
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()

        setNavigationBarButton(items: [
            (.back(title: R.string.localization.return.localized()), .left)
        ])
    }

    private func configShadowView() {
        _ = shadowView.then {
            $0.backgroundColor = ColorName.white.color
            // $0.cornerRadius = 10.0
            $0.dropShadowForContainer()
        }
    }

    private func configWebView() {
        _ = webView.then {
            $0.scrollView.showsVerticalScrollIndicator = false
            $0.scrollView.delegate = self
            $0.navigationDelegate = self
            $0.cornerRadius = 10.0
            $0.masksToBounds = true
        }
        extendBottomInsetIfNeed()

        shadowView.addSubview(webView)
        shadowView.addConstraints(withFormat: "H:|-0-[v0]-0-|", views: webView)
        shadowView.addConstraints(withFormat: "V:|-0-[v0]-0-|", views: webView)
    }
}

// MARK: - Actions

extension TermsViewController {

    override func actionBack() {
        router.close()
    }
}

extension TermsViewController {

    override func setTabBarVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        super.setTabBarVisible(visible, animated: animated, duration: duration)
        if visible {
            extendBottomInsetIfNeed()
        } else {
            extendBottomInsetIfNeed(inset: -(tabBarController?.tabBar.bounds.height ?? 0.0))
        }
    }

    private func extendBottomInsetIfNeed(inset: CGFloat? = nil) {
        var contentInset = webView.scrollView.contentInset
        contentInset.bottom = inset ?? tabBarController?.tabBar.bounds.height ?? 0.0
        webView.scrollView.contentInset = contentInset

        let scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: -contentInset.bottom,
                                                 right: 0)
        if #available(iOS 11.1, *) {
            webView.scrollView.verticalScrollIndicatorInsets = scrollIndicatorInsets
        } else {
            webView.scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        }
    }
}

// MARK: - WKNavigationDelegate

extension TermsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        popHUDActivity()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        popHUDActivity()
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let url = navigationAction.request.url,
                url.host != nil && UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - TermsViewDelegate

extension TermsViewController: TermsViewDelegate {

}
