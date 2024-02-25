//
//  NewsDetailViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 26.01.2024.
//

import Foundation
import UIKit
import SDWebImage

final class NewsDetailViewController: UIViewController {

    // MARK: - Properties

    private let news: News

    // MARK: - Outlets

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Подробнее", for: .normal)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializing

    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        view.backgroundColor = Colors.backgroundGray
        setupGradient()
        setupHierarchy()
        setupLayout()
        binding()
        hideMoreButton()
    }

    // MARK: - SetupUI

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemTeal.cgColor,
            UIColor(red: 253/255, green: 243/255, blue: 120/255, alpha: 1).cgColor,
            UIColor.systemGray6.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.46)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(containerView)
    }

    private func setupHierarchy() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(contentLabel)
    }

    private func setupLayout() {
        contentLabel.setContentHuggingPriority(.required, for: .vertical)
        contentLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        NSLayoutConstraint.activate([

        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        imageView.heightAnchor.constraint(equalToConstant: 200),

        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        titleLabel.heightAnchor.constraint(equalToConstant: 30),

        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
        dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        dateLabel.widthAnchor.constraint(equalToConstant: 200),
        dateLabel.heightAnchor.constraint(equalToConstant: 20),

        contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
        contentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        contentLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }

    // MARK: - Actions
    @objc private func openWebView() {
        let webViewController = WebViewController(content: news)

        if let navigationController = navigationController {
            navigationController.pushViewController(webViewController, animated: true)
        }
    }


    private func hideMoreButton() {
        if news.url != "" {
            view.addSubview(moreButton)
            NSLayoutConstraint.activate([
                moreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                moreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                moreButton.heightAnchor.constraint(equalToConstant: 40),
                moreButton.widthAnchor.constraint(equalToConstant: 120),
            ])
        }
    }

    private func binding() {
        imageView.sd_setImage(with: URL(string: news.image))
        titleLabel.text = news.title
        dateLabel.text = news.date
        contentLabel.text = news.text
    }
}

