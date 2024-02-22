//
//  PlayerTableViewCell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 22.01.2024.
//

import Foundation
import UIKit

final class PlayerTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "CustomPlayerViewCell"

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
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

    private let resultNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetupUI

    private func setupHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(resultNumberLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.heightAnchor.constraint(equalToConstant: 30),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 30),
            photoImageView.widthAnchor.constraint(equalToConstant: 30),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.widthAnchor.constraint(equalToConstant: 220),
            resultNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            resultNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            resultNumberLabel.heightAnchor.constraint(equalToConstant: 30),
            resultNumberLabel.widthAnchor.constraint(equalToConstant: 15),
        ])
    }

    // MARK: - ConfigureCell

    func configure(name: String, image: String, number: Int) {
        nameLabel.text = name
        resultNumberLabel.text = "\(number)"
        photoImageView.getImage(url: image) { imageSize in
            if let imageSize = imageSize {
                self.photoImageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            }
        }
    }

    override func prepareForReuse() {
        self.photoImageView.image = nil
    }
}
