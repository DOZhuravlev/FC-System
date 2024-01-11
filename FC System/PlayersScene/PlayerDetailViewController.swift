//
//  PlayerDetailViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayerDetailViewController: UIViewController {

    var player: Player?

    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let birthdayDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let position: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let aboutPlayer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mvpMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView ()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image

    }()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .lightGray
        setupHierarchy()
        setupLayout()

        name.text = player?.name
        birthdayDate.text = player?.birthdayDate
        position.text = player?.position.rawValue
        aboutPlayer.text = player?.aboutPlayer
        mvpMonth.text = player?.mvpMonth
        image.image = UIImage(named: player?.image ?? "")

    }



//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .lightGray
//        setupHierarchy()
//        setupLayout()
//
//
//
//    }

    private func setupHierarchy() {
        view.addSubview(image)
        view.addSubview(name)
        view.addSubview(birthdayDate)
        view.addSubview(position)
        view.addSubview(aboutPlayer)
        view.addSubview(mvpMonth)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -430),
            name.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            birthdayDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            birthdayDate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            position.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            position.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 170),
            mvpMonth.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            mvpMonth.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 190),
            aboutPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            aboutPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 210)
        ])
    }
}
