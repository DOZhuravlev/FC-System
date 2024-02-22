//
//  TrainingListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class TheoryViewController: UIViewController {

    // MARK: - Outlets

    private var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame = CGRect(x: 0, y: 0, width: image.intrinsicContentSize.width, height: image.intrinsicContentSize.height)
        return image
    }()

    private let theoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Теория"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()

    private let theoryLabelViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .systemGray6
        setupGradient()
        view.addSubview(image)
        view.addSubview(theoryLabelViewContainer)
        theoryLabelViewContainer.addSubview(theoryLabel)
        image.image = UIImage(named: "klipartz.com")
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 180),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            theoryLabelViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            theoryLabelViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            theoryLabelViewContainer.heightAnchor.constraint(equalToConstant: 30),
            theoryLabelViewContainer.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40),
            theoryLabel.leadingAnchor.constraint(equalTo: theoryLabelViewContainer.leadingAnchor),
            theoryLabel.trailingAnchor.constraint(equalTo: theoryLabelViewContainer.trailingAnchor),
            theoryLabel.topAnchor.constraint(equalTo: theoryLabelViewContainer.topAnchor),
            theoryLabel.bottomAnchor.constraint(equalTo: theoryLabelViewContainer.bottomAnchor)
        ])
        setupTiles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - SetupUI

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 253/255, green: 243/255, blue: 120/255, alpha: 1).cgColor,
            UIColor(red: 253/255, green: 243/255, blue: 120/255, alpha: 1).cgColor,
            UIColor.systemGray6.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.52)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(containerView)
    }

    private func setupTiles() {
        let attackButton = createTileButton(imageName: "attackIcon1", labelText: "Атака")
        let defenceButton = createTileButton(imageName: "defenceIcon", labelText: "Защита")
        let tabletButton = createTileButton(imageName: "3dField", labelText: "Планшет")

        let stackView = UIStackView(arrangedSubviews: [attackButton, defenceButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center

        let mainStackView = UIStackView(arrangedSubviews: [stackView, tabletButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center

        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: theoryLabel.bottomAnchor, constant: 30)
        ])
        attackButton.addTarget(self, action: #selector(attackButtonTapped), for: .touchUpInside)
        defenceButton.addTarget(self, action: #selector(defenceButtonTapped), for: .touchUpInside)
        tabletButton.addTarget(self, action: #selector(tabletButtonTapped), for: .touchUpInside)
        attackButton.isUserInteractionEnabled = true
        view.bringSubviewToFront(attackButton)
    }


    private func createTileButton(imageName: String, labelText: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
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
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 25),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 0)
        ])

        let label = UILabel()
        label.text = labelText
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 5)
        ])
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 150)
        ])
        return button
    }

    // MARK: - Actions

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @objc private func attackButtonTapped() {
        showAlert(title: "Тренировки не найдены!", message: "Будут позже")
    }

    @objc private func defenceButtonTapped() {
        showAlert(title: "Тренировки не найдены!", message: "Будут позже")
    }

    @objc private func tabletButtonTapped() {
        let vc = FootballFieldViewController()
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
