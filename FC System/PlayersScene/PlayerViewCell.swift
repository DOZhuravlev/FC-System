//
//  Cell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit
import SDWebImage

final class PlayerViewCell: UICollectionViewCell {

    // MARK: - Outlets

    static let identifier = "playerCell"

    // MARK: - Outlets

    private var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
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
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        image.backgroundColor = .systemGray6
        mainStack.backgroundColor = .systemGray6
        backgroundView?.backgroundColor = .systemGray6
        shadowView.backgroundColor = .systemGray6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        addSubview(mainStack)
        mainStack.addSubview(label)
        mainStack.addSubview(image)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            image.topAnchor.constraint(equalTo: mainStack.topAnchor),
            image.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: -15),

            label.widthAnchor.constraint(equalTo: mainStack.widthAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 0)

        ])
    }
    // MARK: - ConfigCell

    override func prepareForReuse() {
        self.image.image = nil
    }

    func configure(player: Player) {
        guard let playerImage = player.image else { return }
        image.sd_setImage(with: URL(string: playerImage), placeholderImage: UIImage(named: "siluet"))
        label.text = player.name
    }
}
