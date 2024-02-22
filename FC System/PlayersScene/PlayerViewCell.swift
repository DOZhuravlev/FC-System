//
//  Cell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayerViewCell: UICollectionViewCell {

    // MARK: - Outlets

    static let identifier = "playerCell"

    // MARK: - Outlets

    private var image: ConfigImageView = {
        let image = ConfigImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .white
        stack.layer.shadowColor = UIColor.systemGray2.cgColor
        stack.layer.shadowOpacity = 10
        stack.layer.shadowOffset = .zero
        stack.layer.shadowRadius = 10
        stack.layer.cornerRadius = 10
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(shadowView)
        shadowView.addSubview(image)
        mainStack.addArrangedSubview(label)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: 210),
            mainStack.widthAnchor.constraint(equalToConstant: 170),
            label.widthAnchor.constraint(equalToConstant: 166)
        ])
    }
    // MARK: - ConfigCell

    func configure(player: Player) {

        guard let playerImage = player.image else { return }

        image.getImage(url: playerImage) { imageSize in
            if let imageSize = imageSize {
                self.image.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            }
        }
        label.text = player.name
    }

    override func prepareForReuse() {
        self.image.image = nil
        self.label.text = ""
    }
}
