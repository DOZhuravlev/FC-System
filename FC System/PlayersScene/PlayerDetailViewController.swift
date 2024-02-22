//
//  PlayerDetailViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayerDetailViewController: UIViewController {

    // MARK: - Properties

    var playersStat: PlayerStat

    // MARK: - Outlets

    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let position: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let aboutPlayerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private var image: ConfigImageView = {
        let image = ConfigImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 30
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 30
        image.clipsToBounds = true
        return image
    }()

    private var shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 5
        view.layer.shadowOffset = .zero
        return view
    }()

    private let statisticsSeasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Статистика в текущем сезоне"
        return label
    }()

    private let gamesInSeasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let goalsInSeasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let assistsInSeasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statisticsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers

    init(playersStat: PlayerStat) {
        self.playersStat = playersStat
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupHierarchy()
        setupLayout()
        binding()
        setupPositionPlayers()
    }

    // MARK: - Binding

    private func binding() {
        guard let imageUrl = playersStat.image else { return }
        image.getImage(url: imageUrl) { imageSize in
            if let imageSize = imageSize {
                self.image.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            }
        }

        createLabelsForStackView(imageStack: "stadium" ,text1: String(playersStat.games ?? 0), text2: "Игр", in: statisticsStackView)
        createLabelsForStackView(imageStack: "ball", text1: String(playersStat.goals ?? 0), text2: "Голов", in: statisticsStackView)
        createLabelsForStackView(imageStack: "boots", text1: String(playersStat.assist ?? 0), text2: "Ассистов", in: statisticsStackView)

        name.text = playersStat.name
        position.text = playersStat.position
    }

    // MARK: - SetupUI

    private func createLabelsForStackView(imageStack: String, text1: String, text2: String, in stackView: UIStackView) {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3

        let image = UIImageView()
        image.image = UIImage(named: imageStack)

        let label1 = UILabel()
        label1.text = text1
        label1.textColor = .black
        label1.font = .boldSystemFont(ofSize: 28)

        let label2 = UILabel()
        label2.text = text2
        label2.textColor = .systemGray
        label2.font = .boldSystemFont(ofSize: 14)

        let labelsStackView = UIStackView(arrangedSubviews: [image, label1, label2])
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        labelsStackView.spacing = 2

        view.addSubview(labelsStackView)

        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stackView.addArrangedSubview(view)
    }

    private func setupHierarchy() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemTeal.cgColor,
            UIColor(red: 253/255, green: 243/255, blue: 120/255, alpha: 1).cgColor,
            UIColor.systemGray6.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.52)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(containerView)
        view.addSubview(position)
        view.addSubview(shadowView)
        shadowView.addSubview(image)
        view.addSubview(name)
        view.addSubview(statisticsSeasonLabel)
        view.addSubview(statisticsStackView)
    }

    private func setupPositionPlayers() {
        let aboutPlayerLabelTopConstraint = aboutPlayerLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10)
        let aboutPlayerLabelLeadingConstraint = aboutPlayerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        let aboutPlayerLabelTrailingConstraint = aboutPlayerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        aboutPlayerLabel.setContentHuggingPriority(.required, for: .vertical)
        aboutPlayerLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        if playersStat.position == "Тренер" {
            statisticsSeasonLabel.isHidden = true
            statisticsStackView.isHidden = true

            view.addSubview(aboutPlayerLabel)
            aboutPlayerLabel.text = playersStat.descriptionPlayer

            NSLayoutConstraint.activate([
                aboutPlayerLabelTopConstraint,
                aboutPlayerLabelLeadingConstraint,
                aboutPlayerLabelTrailingConstraint
            ])
        }

        if playersStat.position == "Вратарь" {
            createLabelsForStackView(imageStack: "gates", text1: playersStat.gatesZero ?? "0", text2: "На ноль", in: statisticsStackView)
        }

        if playersStat.descriptionPlayer != "", playersStat.position != "Тренер"  {
            view.addSubview(aboutPlayerLabel)
            aboutPlayerLabel.text = playersStat.descriptionPlayer

            NSLayoutConstraint.activate([
                aboutPlayerLabel.topAnchor.constraint(equalTo: statisticsStackView.bottomAnchor, constant: 5),
                aboutPlayerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                aboutPlayerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
        }

        if playersStat.name == "Илья Беляк" {
            createLabelsForStackView(imageStack: "gates", text1: playersStat.gatesZero ?? "0", text2: "На ноль", in: statisticsStackView)
            statisticsSeasonLabel.isHidden = false
            statisticsStackView.isHidden = false

            aboutPlayerLabelTopConstraint.isActive = false
            aboutPlayerLabelLeadingConstraint.isActive = false
            aboutPlayerLabelTrailingConstraint.isActive = false

            NSLayoutConstraint.activate([
                aboutPlayerLabel.topAnchor.constraint(equalTo: statisticsStackView.bottomAnchor, constant: 10),
                aboutPlayerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                aboutPlayerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            position.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            position.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            shadowView.topAnchor.constraint(equalTo: position.bottomAnchor, constant: 5),
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 200),
            shadowView.heightAnchor.constraint(equalToConstant: 200),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticsSeasonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticsSeasonLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 15),
            statisticsStackView.topAnchor.constraint(equalTo: statisticsSeasonLabel.bottomAnchor, constant: 10),
            statisticsStackView.heightAnchor.constraint(equalToConstant: 120),
            statisticsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
