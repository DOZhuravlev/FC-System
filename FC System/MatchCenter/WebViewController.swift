//
//  WebViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 01.02.2024.
//

import Foundation
import UIKit
import WebKit

protocol WebViewContentProtocol {
    var url: String { get }
}

final class WebViewController: UIViewController {

    // MARK: - Properties

    private let content: WebViewContentProtocol

    // MARK: - Outlets

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Initializers

    init(content: WebViewContentProtocol) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebView()
    }

    // MARK: - SetupUI

    private func setupUI() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Actions

    private func loadWebView() {
        if let url = URL(string: content.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

