//
//  PlayerCellHeader.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayersCellHeader: UICollectionReusableView {

    // MARK: - Properties

    static let identifier = "PlayersCellHeader"

    // MARK: - Outlets

    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - SetupUI

    private func setupLayout() {
        title.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }

}
