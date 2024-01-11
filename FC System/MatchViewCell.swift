//
//  MatchViewCell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class MatchViewCell: UICollectionViewCell {

    static let identifier = "matchCell"

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

    lazy var name: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var tourName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var systemaTeamName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textAlignment = .center

        return label
    }()

    lazy var rivalTeamName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textAlignment = .center

        return label
    }()

    lazy var dateMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var timeMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var scoreMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
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

    lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .red
        return stack

    }()


    lazy var middleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .green
        return stack

    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        backgroundColor = .blue

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        addSubview(mainStack)
        addSubview(topStack)
        addSubview(middleStack)
      //  mainStack.addArrangedSubview(image)
        topStack.addArrangedSubview(name)
        topStack.addArrangedSubview(tourName)
        middleStack.addArrangedSubview(systemaTeamName)
        middleStack.addArrangedSubview(scoreMatch)
        middleStack.addArrangedSubview(rivalTeamName)
        addSubview(dateMatch)
        addSubview(timeMatch)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.heightAnchor.constraint(equalToConstant: 170),
            mainStack.widthAnchor.constraint(equalToConstant: 220),
            topStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            topStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            topStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            topStack.heightAnchor.constraint(equalToConstant: 30),
            middleStack.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            middleStack.widthAnchor.constraint(equalToConstant: 220),
            middleStack.heightAnchor.constraint(equalToConstant: 50),
            dateMatch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            dateMatch.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            dateMatch.heightAnchor.constraint(equalToConstant: 15),
            timeMatch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            timeMatch.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            timeMatch.heightAnchor.constraint(equalToConstant: 15),
            scoreMatch.centerXAnchor.constraint(equalTo: middleStack.centerXAnchor, constant: 0)
        ])
    }

    override func prepareForReuse() {
        self.image.image = nil
    }

    func setupCell(imageMatch: UIImage?, nameMatch: String, tour: String, systemaName: String, rivalName: String, score: String, date: String, time: String) {
        image.image = imageMatch
        name.text = nameMatch
        tourName.text = tour
        systemaTeamName.text = systemaName
        rivalTeamName.text = rivalName
        scoreMatch.text = score
        dateMatch.text = date
        timeMatch.text = time
    }
}
