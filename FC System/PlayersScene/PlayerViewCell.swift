//
//  Cell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayerViewCell: UICollectionViewCell {

    static let identifier = "playerCell"

    // MARK: - Outlets

    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.shadowColor = UIColor.systemPink.cgColor
        image.layer.shadowOpacity = 0.8
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 10
        image.layer.shouldRasterize = true
        image.layer.rasterizationScale = UIScreen.main.scale

        return image
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var mainStack: UIStackView = {
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(image)
        mainStack.addArrangedSubview(label)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.heightAnchor.constraint(equalToConstant: 220),
            mainStack.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    override func prepareForReuse() {
        self.image.image = nil
    }

    func setupCell(imagePlayer: UIImage?, namePlayer: String){
        image.image = imagePlayer
        label.text = namePlayer
    }
}
