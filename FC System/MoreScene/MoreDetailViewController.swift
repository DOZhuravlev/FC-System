//
//  MoreDetailViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 13.02.2024.
//

import Foundation
import UIKit
import MapKit

final class MoreDetailViewController: UIViewController {

    // MARK: - Properties

    private let coordinateTrainingField = CLLocationCoordinate2D(latitude: 56.893586, longitude: 60.647498)
    private let coordinateStadiumForGames = CLLocationCoordinate2D(latitude: 56.840325, longitude: 60.54899)
    private var about: Item

    // MARK: - Initializers

    init(about: Item) {
        self.about = about
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Outlets

    private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        return mapView
    }()

    private var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 5
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()

    private let nameLabelViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let pushLabel: UILabel = {
        let label = UILabel()
        label.text = "Push уведомления ВКЛ/ВЫКЛ"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var pushSwitch: UISwitch = {
        let pushSwitch = UISwitch()
        pushSwitch.translatesAutoresizingMaskIntoConstraints = false
        pushSwitch.onTintColor = .systemMint
        pushSwitch.isOn = true
        pushSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return pushSwitch
    }()

    private lazy var pushStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pushLabel, pushSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        showGradient()
        setupHierarchy()
        setupLayout()
        binding()
        mapView.delegate = self
    }

    // MARK: - SetupUI

    private func showGradient() {
        switch about {
        case .description(color: let color):
            setupGradient(color: color)
        case .fieldForTraining(color: let color):
            setupGradient(color: color)
        case .stadiumForGames(color: let color):
            setupGradient(color: color)
        case .setup(color: let color):
            setupGradient(color: color)
        }
    }

    // MARK: - Binding

    private func binding() {
        switch about {
        case .description(color: _):
            nameLabel.text = "О команде"
            image.image = UIImage(named: "team")
            descriptionLabel.text = TextForLabels.aboutTeamDescription
            showDescriptionTeam()

        case .fieldForTraining(color: _):
            nameLabel.text = "Поле для тренировок"
            image.image = UIImage(named: ImageNames.trainingField)
            showMapView(coordinate: coordinateTrainingField, title: "Калининец", subTitle: "Краснофлотцев 48")

        case .stadiumForGames(color: _):
            nameLabel.text = "Стадион для игр"
            image.image = UIImage(named: ImageNames.stadiumForGames)
            showMapView(coordinate: coordinateStadiumForGames, title: "Стадион на Кирова", subTitle: "Кирова 40")

        case .setup(color: _):
            nameLabel.text = "Настройки"
            shadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = false
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = false
            shadowView.widthAnchor.constraint(equalToConstant: 350).isActive = false
            shadowView.heightAnchor.constraint(equalToConstant: 250).isActive = false

            image.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = false
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = false
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = false
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = false

            nameLabelViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = false
            nameLabelViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = false
            nameLabelViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = false
            nameLabelViewContainer.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = false

            nameLabel.leadingAnchor.constraint(equalTo: nameLabelViewContainer.leadingAnchor).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: nameLabelViewContainer.trailingAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: nameLabelViewContainer.topAnchor).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor).isActive = true

            image.removeFromSuperview()
            shadowView.removeFromSuperview()
            view.addSubview(image)

            view.addSubview(pushStackView)

            image.image = UIImage(named: "settingsSticker")
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
            image.heightAnchor.constraint(equalToConstant: 200).isActive = true

            nameLabelViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            nameLabelViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            nameLabelViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabelViewContainer.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40).isActive = true

            nameLabel.leadingAnchor.constraint(equalTo: nameLabelViewContainer.leadingAnchor).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: nameLabelViewContainer.trailingAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: nameLabelViewContainer.topAnchor).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor).isActive = true

            NSLayoutConstraint.activate([
                pushStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pushStackView.topAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor, constant: 50)
            ])
        }
    }

    // MARK: - SetupUI

    private func setupGradient(color: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            color.cgColor,
            color.cgColor,
            UIColor.systemGray5.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.57)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(containerView)
    }

    private func setupHierarchy() {
        view.addSubview(shadowView)
        shadowView.addSubview(image)
        view.addSubview(nameLabelViewContainer)
        nameLabelViewContainer.addSubview(nameLabel)
    }

    private func setupLayout() {
        shadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        image.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true

        nameLabelViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabelViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nameLabelViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabelViewContainer.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: nameLabelViewContainer.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: nameLabelViewContainer.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: nameLabelViewContainer.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor).isActive = true
    }

    // MARK: - Actions

    private func showMapView(coordinate: CLLocationCoordinate2D, title: String, subTitle: String) {
        let coordinate = coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 900, longitudinalMeters: 900)
        mapView.setRegion(region, animated: true)
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.topAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }

    private func showDescriptionTeam() {
        view.addSubview(descriptionLabel)
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabelViewContainer.bottomAnchor, constant: 10),
        ])
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            registerForPushNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }

    private func registerForPushNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }

    private func unregisterForPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}

// MARK: - MKMapViewDelegate

extension MoreDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}

