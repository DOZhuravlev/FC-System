//
//  PlayersListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

enum PlayerPosition: String, CaseIterable {
    case coach = "Тренер"
    case goalkeeper = "Вратарь"
    case defender = "Защитник"
    case midfielder = "Полузащитник"
    case forward = "Нападающий"

    static var count: Int {
        return PlayerPosition.allCases.count
    }
}

final class PlayersListViewController: UIViewController {

    // MARK: - Properties

    var players: [Player] = []
    var matches: [Match] = []
    var filteredMatches: [Match] = []
    var currentSeason: String?
    var statData: [PlayerStat] = []

    //MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlayerViewCell.self, forCellWithReuseIdentifier: PlayerViewCell.identifier)
        collectionView.register(PlayersCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayersCellHeader.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        fetchData { [weak self] in
            guard let self = self else { return }
            collectionView.reloadData()
            fetchStatData()
        }
        setupLayout()
    }

    //MARK: - SetupUI

    private func setupHierarchy() {
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - FetchData

    private func fetchData(completion: @escaping () -> Void) {

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        FirestoreService.shared.fetchItems(for: .currentSeason) { [weak self] (result: Result<[CurrentSeason], Error>) in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let currentSeason):
                if let season = currentSeason.first?.idSeason {
                    self.currentSeason = season
                }
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.enter()
        FirestoreService.shared.fetchItems(for: .players) { [weak self] (result: Result<[Player], Error>) in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let players):
                self.players = players
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.enter()
        FirestoreService.shared.fetchItems(for: .matches) { [weak self] (result: Result<[Match], Error>) in
            guard let self = self else { return }
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let matches):
                self.matches = matches
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    private func fetchStatData() {
        statData = getStatData()
    }

    private func getStatData() -> [PlayerStat] {
        filteredMatches = matches.filter({$0.idSeason == currentSeason})
        var tableData: [PlayerStat] = []

        var gamesCountPlayer: [String: Int] = [:]
        var goalsCountPlayer: [String: Int] = [:]
        var assistCountPlayer: [String: Int] = [:]

        for game in filteredMatches {
            var gamePlayers: [String] = []
            gamePlayers.append(contentsOf: game.squad)
            for player in gamePlayers {
                gamesCountPlayer[player, default: 0] += 1
            }
        }

        for goal in filteredMatches {
            var goalPlayers: [String] = []
            goalPlayers.append(contentsOf: goal.goalsPlayers)
            for player in goalPlayers {
                goalsCountPlayer[player, default: 0] += 1
            }
        }

        for assist in filteredMatches {
            var assistPlayers: [String] = []
            assistPlayers.append(contentsOf: assist.assistPlayers)

            for player in assistPlayers {
                assistCountPlayer[player, default: 0] += 1
            }
        }

        for player in players {
            let gamesCount = gamesCountPlayer[player.id]
            let goalsCount = goalsCountPlayer[player.id]
            let assistCount = assistCountPlayer[player.id]

            let tableItem = PlayerStat(name: player.name, image: player.image, goals: goalsCount, games: gamesCount, assist: assistCount, gatesZero: player.zeroGameGk ?? "", position: player.position, descriptionPlayer: player.descriptionPlayer)
            tableData.append(tableItem)
        }
        return tableData
    }
}

// MARK: - SetupCollectionView

extension PlayersListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PlayerPosition.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentSectionPosition = PlayerPosition.allCases[section]
        let playersInSection = players.filter { $0.position == currentSectionPosition.rawValue }
        return playersInSection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerViewCell.identifier, for: indexPath) as? PlayerViewCell else { return UICollectionViewCell() }
        let currentSectionPosition = PlayerPosition.allCases[indexPath.section]
        let playersInSection = players.filter { $0.position == currentSectionPosition.rawValue }
        let player = playersInSection[indexPath.item]
        cell.configure(player: player)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 28, bottom: 10, right: 28)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
            let horizontalSpacing: CGFloat = 30 // Расстояние между элементами по горизонтали
            let paddingSpace = horizontalSpacing * (numberOfColumns + 1) // Расстояние между элементами + отступы с каждой стороны
            let availableWidth = collectionView.bounds.width - paddingSpace
            let itemWidth = availableWidth / numberOfColumns
            let itemHeight = itemWidth * 1.3 // Например, я взял 1.3 как соотношение ширины и высоты ячейки
            return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayersCellHeader.identifier, for: indexPath) as! PlayersCellHeader

        switch indexPath.section {
        case 0:
            header.title.text = "Тренеры"
        case 1:
            header.title.text = "Вратари"
        case 2:
            header.title.text = "Защитники"
        case 3:
            header.title.text = "Полузащитники"
        case 4:
            header.title.text = "Нападающие"
        default:
            header.title.text = "Другая секция"
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSectionPosition = PlayerPosition.allCases[indexPath.section]
        let playersInSection = players.filter { $0.position == currentSectionPosition.rawValue }
        let player = playersInSection[indexPath.item]
        if let playerStat = statData.first(where: { $0.name == player.name }) {
            let vc = PlayerDetailViewController(playersStat: playerStat)
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
}
