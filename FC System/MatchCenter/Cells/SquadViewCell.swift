//
//  MatchCenterViewCell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 31.01.2024.
//

import Foundation
import UIKit

final class SquadViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "squadViewCell"

    // MARK: - Outlets

    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let photoImageView: ConfigImageView = {
        let imageView = ConfigImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let ballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ball")
        return imageView
    }()

    private let bootsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "boots")
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let assistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycles

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        contentView.backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetupUI

    private func setupHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ballImageView)
        contentView.addSubview(bootsImageView)
        contentView.addSubview(goalLabel)
        contentView.addSubview(assistLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.heightAnchor.constraint(equalToConstant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 20),
            photoImageView.widthAnchor.constraint(equalToConstant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 220),
            ballImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            ballImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ballImageView.heightAnchor.constraint(equalToConstant: 20),
            ballImageView.widthAnchor.constraint(equalToConstant: 20),
            goalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            goalLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goalLabel.heightAnchor.constraint(equalToConstant: 20),
            goalLabel.widthAnchor.constraint(equalToConstant: 20),
            bootsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            bootsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bootsImageView.heightAnchor.constraint(equalToConstant: 20),
            bootsImageView.widthAnchor.constraint(equalToConstant: 20),
            assistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            assistLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            assistLabel.heightAnchor.constraint(equalToConstant: 20),
            assistLabel.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

    // MARK: - ConfigureCell

    func configure(player: Player, match: Match, goalsCount: Int? = nil, assistCount: Int? = nil) {
        nameLabel.text = player.name
        guard let playerImage = player.image else { return }
        photoImageView.getImage(url: playerImage) { imageSize in
            if let imageSize = imageSize {
                DispatchQueue.main.async {
                    self.photoImageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                }
            }
        }

        ballImageView.isHidden = true
        goalLabel.isHidden = true
        bootsImageView.isHidden = true
        assistLabel.isHidden = true

        if let goalsCount = goalsCount, let assistCount = assistCount {
            goalLabel.text = "x\(goalsCount)"
            assistLabel.text = "x\(assistCount)"
            ballImageView.isHidden = false
            goalLabel.isHidden = false
            bootsImageView.isHidden = false
            assistLabel.isHidden = false
        }

        if let goalsCount = goalsCount {
            goalLabel.text = "x\(goalsCount)"
            ballImageView.isHidden = false
            goalLabel.isHidden = false
        }

        if let assistCount = assistCount {
            assistLabel.text = "x\(assistCount)"
            bootsImageView.isHidden = false
            assistLabel.isHidden = false
        }
    }

    override func prepareForReuse() {
        self.photoImageView.image = nil
    }
}
