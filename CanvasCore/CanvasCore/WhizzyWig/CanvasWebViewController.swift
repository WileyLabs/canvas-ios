//
// This file is part of Canvas.
// Copyright (C) 2017-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import WebKit
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Core

open class CanvasWebViewController: UIViewController, PageViewEventViewControllerLoggingProtocol {
    @objc public let webView: CanvasWebView
    @objc public var pageViewName: String?
    private let showDoneButton: Bool
    private let showShareButton: Bool
    @objc public var showReloadButton: Bool = true
    
    let canBack: DynamicProperty<Bool>
    let canForward: DynamicProperty<Bool>
    let isLoading: DynamicProperty<Bool>
    let webTitle: DynamicProperty<String>
    
    @objc public init(webView: CanvasWebView = CanvasWebView(), showDoneButton: Bool = false, showShareButton: Bool = false) {
        self.webView = webView
        self.showDoneButton = showDoneButton
        self.showShareButton = showShareButton
        
        canBack = DynamicProperty(object: webView, keyPath: "canGoBack")
        canForward = DynamicProperty(object: webView, keyPath: "canGoForward")
        isLoading = DynamicProperty(object: webView, keyPath: "loading")
        webTitle = DynamicProperty(object: webView, keyPath: "title")
        
        super.init(nibName: nil, bundle: nil)

        webView.requestClose = { [weak self] in self?.done() }
        webView.presentingViewController = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(webView)
        webView.pin(inside: view)
        buildUI()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: animated)
        startTrackingTimeOnViewController()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
        if let pageViewName = pageViewName  {
            stopTrackingTimeOnViewController(eventName: pageViewName)
        }
    }
    
    // MARK: initialize UI
    
    @objc func buildUI() {
        if self.showDoneButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        }
        
        navigationItem.reactive.title <~ webTitle
        updateToolbarItems()
    }
    
    @objc func updateToolbarItems() {
        let back = UIBarButtonItem(image: .icon(.backward), style: .plain, target: webView, action: #selector(WKWebView.goBack))
        back.reactive.isEnabled <~ canBack.producer
        
        let forward = UIBarButtonItem(image: .icon(.forward), style: .plain, target: webView, action: #selector(WKWebView.goForward))
        forward.reactive.isEnabled <~ canForward.producer
        
        let loadingActivity = UIActivityIndicatorView(style: .gray)
        loadingActivity.reactive.isAnimating <~ isLoading.producer

        let loading = UIBarButtonItem(customView: loadingActivity)
        let space: () -> UIBarButtonItem = {
            return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }

        var reload: UIBarButtonItem?
        if showReloadButton {
            reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(WKWebView.reload))
        }

        var share: UIBarButtonItem?
        if showShareButton {
            share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        }
        
        let barItems = [
            back,
            space(),
            forward,
            space(),
            reload,
            space(),
            share,
            space(),
            loading
        ]
        toolbarItems = barItems.compactMap { $0 }
    }

    // MARK: Actions
    @objc
    func done() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func didTapShareButton(sender: UIBarButtonItem) {
        guard let url = webView.url, let presentingViewController = webView.presentingViewController else {
            return
        }
        let safariActivity = SafariActivity()
        let viewController = UIActivityViewController(activityItems: [url], applicationActivities: [safariActivity])
        viewController.popoverPresentationController?.barButtonItem = sender
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
}
