//
//  MoreViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

enum Item {
    case description(color: UIColor)
    case fieldForTraining(color: UIColor)
    case stadiumForGames(color: UIColor)
    case setup(color: UIColor)
}

final class MoreViewController: UIViewController {

    // MARK: - Properties

    private var setupApp: [SetupApp] = []
    private var aboutClubButton: UIButton!
    private var fieldForTrainingButton: UIButton!
    private var stadiumForGamesButton: UIButton!
    private var setupUserButton: UIButton!
    private var rateTheAppButton: UIButton!

    // MARK: - Outlets

    private let aboutClubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let fieldForTrainingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let stadiumForGamesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let setupUserView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let rateTheAppView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let versionAppLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Версия 1.0"
        return label
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupButtons()
        fetchSetupApp()
        view.addSubview(versionAppLabel)
        NSLayoutConstraint.activate([
            versionAppLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionAppLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - FetchData

    private func fetchSetupApp() {
        FirestoreService.shared.fetchItems(for: .setupApp) { [weak self] (result: Result<[SetupApp], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let setupApp):
                self.setupApp = setupApp
                DispatchQueue.main.async {
                    self.versionAppLabel.text = setupApp.first?.versionApp
                }
            case .failure(_):
                self.versionAppLabel.text = "Версия 1.0"
            }
        }
    }

    // MARK: - SetupButtons

    private func setupButtons() {
        aboutClubButton = createButton(imageName: "klipartz.com-14", labelText: "О команде", backgroundColor: .systemCyan)
        fieldForTrainingButton = createButton(imageName: "trainingFieldSticker", labelText: "Поле для тренировок", backgroundColor: .systemPurple)
        stadiumForGamesButton = createButton(imageName: "stadiumSticker", labelText: "Стадион для игр", backgroundColor: .systemGreen)
        setupUserButton = createButton(imageName: "settingsSticker", labelText: "Настройки", backgroundColor: .systemMint)
        rateTheAppButton = createButton(imageName: "rateSticker1", labelText: "Оценить приложение в AppStore", backgroundColor: .systemOrange)

        let stackViewFirst = UIStackView(arrangedSubviews: [aboutClubButton!, fieldForTrainingButton!])
        stackViewFirst.axis = .horizontal
        stackViewFirst.spacing = 20
        stackViewFirst.alignment = .center

        let stackViewSecond = UIStackView(arrangedSubviews: [stadiumForGamesButton!, setupUserButton!])
        stackViewSecond.axis = .horizontal
        stackViewSecond.spacing = 20
        stackViewSecond.alignment = .center


        let mainStackView = UIStackView(arrangedSubviews: [stackViewFirst, stackViewSecond, rateTheAppButton!])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center

        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])

        aboutClubButton?.addTarget(self, action: #selector(aboutClubButtonTapped), for: .touchUpInside)
        fieldForTrainingButton?.addTarget(self, action: #selector(fieldForTrainingButtonTapped), for: .touchUpInside)
        stadiumForGamesButton?.addTarget(self, action: #selector(stadiumForGamesButtonTapped), for: .touchUpInside)
        setupUserButton?.addTarget(self, action: #selector(setupUserButtonTapped), for: .touchUpInside)
        rateTheAppButton?.addTarget(self, action: #selector(rateTheAppButtonTapped), for: .touchUpInside)

        aboutClubButton?.isUserInteractionEnabled = true
        view.bringSubviewToFront(aboutClubButton!)
    }

    private func createButton(imageName: String, labelText: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.systemGray2.cgColor
        button.layer.shadowOpacity = 10
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(button)

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 110),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 110),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5)
        ])

        let label = UILabel()
        label.text = labelText
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 170),
            button.heightAnchor.constraint(equalToConstant: 170)
        ])
        return button
    }

    // MARK: - Actions

    @objc private func aboutClubButtonTapped() {
        let buttonColor = aboutClubButton.backgroundColor!
        let color = Item.description(color: buttonColor)
        let vc = MoreDetailViewController(about: color)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    @objc private func fieldForTrainingButtonTapped() {
        let buttonColor = fieldForTrainingButton.backgroundColor!
        let color = Item.fieldForTraining(color: buttonColor)
        let vc = MoreDetailViewController(about: color)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }


    @objc private func stadiumForGamesButtonTapped() {
        let buttonColor = stadiumForGamesButton.backgroundColor!
        let color = Item.stadiumForGames(color: buttonColor)
        let vc = MoreDetailViewController(about: color)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    @objc private func setupUserButtonTapped() {
        let buttonColor = setupUserButton.backgroundColor!
        let color = Item.setup(color: buttonColor)
        let vc = MoreDetailViewController(about: color)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    @objc private func rateTheAppButtonTapped() {
        guard let url = setupApp.first?.urlRateApp else { return }
        guard let writeReviewURL = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}

