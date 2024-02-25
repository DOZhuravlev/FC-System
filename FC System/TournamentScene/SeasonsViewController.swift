//
//  SeasonsViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 12.01.2024.
//

import Foundation
import UIKit

final class SeasonsViewController: UIViewController {

    // MARK: - Properties

    private let verticalSpacing: CGFloat = 20
    private let horizontalSpacing: CGFloat = 20
    private let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    private var statisticsTeam: [StatisticsTeam] = []

    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SeasonViewCell.self, forCellWithReuseIdentifier: SeasonViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        fetchStatistic()
    }

    // MARK: - FetchData

    private func fetchStatistic() {
        FirestoreService.shared.fetchItems(for: .statistics) { [weak self] (result: Result<[StatisticsTeam], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let statisticsTeam):
                self.statisticsTeam = statisticsTeam
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - SetupCollectionView

extension SeasonsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticsTeam.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonViewCell.identifier, for: indexPath) as? SeasonViewCell else { return UICollectionViewCell() }
        let name = statisticsTeam[indexPath.item].nameSeason
        let icon = statisticsTeam[indexPath.item].iconName
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 15
        cell.configure(seasonName: name, icon: icon)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idSeason = statisticsTeam[indexPath.item].idSeason
        let statistics = statisticsTeam[indexPath.item]
        let vc = MatchesListViewController(statisticsTeam: statistics)
        if let navigationController = navigationController {
            vc.idSeason = idSeason
            navigationController.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let availableWidth = collectionViewWidth - sectionInsets.left - sectionInsets.right - horizontalSpacing
        return CGSize(width: availableWidth, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

