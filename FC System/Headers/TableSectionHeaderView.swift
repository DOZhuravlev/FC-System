//
//  TableSectionHeaderView.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 23.01.2024.
//

import Foundation
import UIKit

final class TableSectionHeaderView: UIView {

    // MARK: - Outlets

    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 110
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    // MARK: - Initializers

    init(labels: [String]) {
        super.init(frame: .zero)
        backgroundColor = .systemGray6

        for labelText in labels {
            let label = UILabel()
            label.text = labelText
            label.textAlignment = .center
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 14)
            labelsStackView.addArrangedSubview(label)
        }

        addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
