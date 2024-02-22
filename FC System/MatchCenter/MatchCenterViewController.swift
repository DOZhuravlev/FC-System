//
//  MatchCenterViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 25.01.2024.
//

import Foundation
import UIKit

final class MatchCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    private let match: Match
    private let players: [Player]
    private var playersData: [String] = []
    private var filteredPlayers: [Player] = []
    private var matches: [Match] = []
    private var filteredMatches: [Match] = []
    private var currentSeason: String?
    private var statData: [PlayerStat] = []

    // MARK: - Outlets

    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "klipartz.com-9")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let tournamentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let tourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()

    private let systemaTeamName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let rivalTeamName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let dateMatch: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let timeMatch: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let scoreMatch: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let middleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()

    private let squadLabel: UILabel = {
        let label = UILabel()
        label.text = "Состав на игру"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray5
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.register(SquadViewCell.self, forCellReuseIdentifier: SquadViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var videoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.setTitle("Видео", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers

    init(match: Match, players: [Player]) {
        self.match = match
        self.players = players
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        binding()
        fetchData { [weak self] in
            guard let self = self else { return }
            fetchStatData()
        }

        setupHierarchy()
        setupLayout()
        playersTableView.delegate = self
        playersTableView.dataSource = self
        filterPlayersForTableView()
    }

    // MARK: - Binding

    private func binding() {
        tournamentLabel.text = match.tournamentName
        tourLabel.text = match.tourNumber
        systemaTeamName.text = match.systemName
        rivalTeamName.text = match.opponentName
        dateMatch.text = match.dateMatch
        timeMatch.text = match.timeMatch
        scoreMatch.text = match.score
        playersData = match.squad
        if match.url == "" {
            videoButton.isHidden = true
        }
    }

    private func filterPlayersForTableView() {
        let playersDataIds = Set(playersData)
        filteredPlayers = players.filter { playersDataIds.contains($0.id) }

        DispatchQueue.main.async {
            self.playersTableView.reloadData()
        }
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

    // MARK: - SetupUI

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 85/255, green: 72/255, blue: 188/255, alpha: 1).cgColor,
            UIColor(red: 85/255, green: 72/255, blue: 188/255, alpha: 1).cgColor,
            UIColor.systemGray5.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.4)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(containerView)
    }

    private func setupHierarchy() {
        view.addSubview(topStack)
        view.addSubview(middleStack)
        topStack.addArrangedSubview(tournamentLabel)
        topStack.addArrangedSubview(tourLabel)
        middleStack.addArrangedSubview(systemaTeamName)
        middleStack.addArrangedSubview(scoreMatch)
        middleStack.addArrangedSubview(rivalTeamName)
        view.addSubview(dateMatch)
        view.addSubview(timeMatch)
        view.addSubview(squadLabel)
        view.addSubview(playersTableView)
        view.addSubview(videoButton)
        view.addSubview(image)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            topStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            topStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topStack.heightAnchor.constraint(equalToConstant: 30),
            middleStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 15),
            middleStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            middleStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateMatch.topAnchor.constraint(equalTo: middleStack.bottomAnchor, constant: 10),
            dateMatch.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            dateMatch.heightAnchor.constraint(equalToConstant: 15),
            timeMatch.topAnchor.constraint(equalTo: dateMatch.bottomAnchor, constant: 0),
            timeMatch.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            timeMatch.heightAnchor.constraint(equalToConstant: 15),
            squadLabel.topAnchor.constraint(equalTo: timeMatch.bottomAnchor, constant: 10),
            squadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            squadLabel.heightAnchor.constraint(equalToConstant: 30),
            squadLabel.widthAnchor.constraint(equalToConstant: 360),
            image.topAnchor.constraint(equalTo: squadLabel.bottomAnchor, constant: 2),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 200),
            playersTableView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 2),
            playersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            playersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            playersTableView.heightAnchor.constraint(equalToConstant: 400),
            videoButton.topAnchor.constraint(equalTo: playersTableView.bottomAnchor, constant: 20),
            videoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            videoButton.heightAnchor.constraint(equalToConstant: 50),
            videoButton.widthAnchor.constraint(equalToConstant: 150),

        ])
    }

    // MARK: - Actions

    @objc private func openWebView() {
        let webViewController = WebViewController(content: match)
        if let navigationController = navigationController {
            navigationController.pushViewController(webViewController, animated: true)
        }
    }

    // MARK: - SetupTableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlayers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SquadViewCell.identifier, for: indexPath) as! SquadViewCell

        let goals = match.goalsPlayers
        var goalsCountPlayer: [String: Int] = [:]
        for player in goals {
            goalsCountPlayer[player, default: 0] += 1
        }

        let assist = match.assistPlayers
        var assistCountPlayer: [String: Int] = [:]
        for player in assist {
            assistCountPlayer[player, default: 0] += 1
        }

        let player = filteredPlayers[indexPath.item]

        if let goalsCount = goalsCountPlayer[player.id], let assistCount = assistCountPlayer[player.id] {
            cell.configure(player: player, match: match, goalsCount: goalsCount, assistCount: assistCount)
        } else if let goalsCount = goalsCountPlayer[player.id] {
            cell.configure(player: player, match: match, goalsCount: goalsCount, assistCount: nil)
        } else if let assistCount = assistCountPlayer[player.id] {
            cell.configure(player: player, match: match, goalsCount: nil, assistCount: assistCount)
        } else {
            cell.configure(player: player, match: match, goalsCount: nil, assistCount: nil)
        }

        cell.numberLabel.text = "\(indexPath.row + 1)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let player = filteredPlayers[indexPath.item]

        if let playerStat = statData.first(where: { $0.name == player.name }) {
            let vc = PlayerDetailViewController(playersStat: playerStat)
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
}
