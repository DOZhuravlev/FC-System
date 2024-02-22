//
//  MatchViewCell.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class MatchViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "matchCell"

    // MARK: - Outlets

    private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "klipartz.com-3")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var name: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tourName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var systemaTeamName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var rivalTeamName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var dateMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var timeMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var scoreMatch: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
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

    private var topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        return stack

    }()

    private var middleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        backgroundColor = .systemGray6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - SetupUI

    private func setupHierarchy() {
        addSubview(topStack)
        addSubview(middleStack)
        topStack.addArrangedSubview(name)
        topStack.addArrangedSubview(tourName)
        middleStack.addArrangedSubview(systemaTeamName)
        middleStack.addArrangedSubview(scoreMatch)
        middleStack.addArrangedSubview(rivalTeamName)
        addSubview(dateMatch)
        addSubview(timeMatch)

        addSubview(image)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
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
            scoreMatch.centerXAnchor.constraint(equalTo: middleStack.centerXAnchor, constant: 0),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }

    // MARK: - ConfigureCell

    func configure(match: Match) {
        name.text = match.tournamentName
        tourName.text = match.tourNumber
        systemaTeamName.text = match.systemName
        rivalTeamName.text = match.opponentName
        scoreMatch.text = match.score
        dateMatch.text = match.dateMatch
        timeMatch.text = match.timeMatch
    }
}
