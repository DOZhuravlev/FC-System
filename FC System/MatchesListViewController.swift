//
//  MatchesListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

enum ResultsAction {
    case goals(array: [PlayerStat])
    case assist(array: [PlayerStat])
}

final class MatchesListViewController: UIViewController {
    
    // MARK: - Properties
    var idSeason: String = ""
    private var matches: [Match] = []
    private var players: [Player] = []
    private var statisticsTeam: StatisticsTeam
    private var filteredMatches: [Match] = []
    private var currentSeason: String?
    private var statData: [PlayerStat] = []
    private var sortedGoalsTableData: [PlayerStat] = []
    private var sortedAssistTableData: [PlayerStat] = []
    
    // MARK: - Outlets
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: MatchViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.layer.cornerRadius = 20
        return collectionView
    }()
    
    private lazy var collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let seasonTableImage: ConfigImageView = {
        let image = ConfigImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var seasonTableImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let tableNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Турнирная таблица"
        return label
    }()
    
    private let statsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Статистика команды"
        return label
    }()
    
    private let statisticsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.shadowColor = UIColor.systemGray2.cgColor
        stackView.layer.shadowOpacity = 3
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowRadius = 3
        return stackView
    }()
    
    private let statisticsUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let statisticsLowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let matchesNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Матчи"
        return label
    }()
    
    private let goalsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Бомбардиры"
        return label
    }()
    
    private lazy var goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private lazy var goalsTableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let passesNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Голевые передачи"
        return label
    }()
    
    private lazy var passesTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private lazy var passesTableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        return view
    }()
    
    private lazy var seeAllPassesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Все", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(seeAllPassesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var seeAllGoleadorsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Все", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(seeAllGoleadorsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    init(statisticsTeam: StatisticsTeam) {
        self.statisticsTeam = statisticsTeam
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        fetchData() { [weak self] in
            guard let self = self else { return }
            update()
            DispatchQueue.main.async {
                self.goalsTableView.reloadData()
                self.passesTableView.reloadData()
            }
        }
        setupHierarchy()
        setupLayout()
        binding()
    }
    
    // MARK: - FetchData
    
    private func fetchData(completion: @escaping () -> Void) {
        FirestoreService.shared.fetchItems(for: .currentSeason) { [weak self] (result: Result<[CurrentSeason], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let currentSeason):
                self.currentSeason = currentSeason.first?.idSeason
            case .failure(let error):
                print(error)
            }
        }
        
        FirestoreService.shared.fetchItems(for: .players) { [weak self] (result: Result<[Player], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let players):
                self.players = players
                completion()
            case .failure(let error):
                print(error)
            }
        }
        
        FirestoreService.shared.fetchItems(for: .matches) { [weak self] (result: Result<[Match], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let matches):
                self.matches = matches
                self.matches.reverse()
                self.update()
                
                DispatchQueue.main.async {
                    self.goalsTableView.reloadData()
                    self.passesTableView.reloadData()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getStatData() -> [PlayerStat] {
        filteredMatches = matches.filter({$0.idSeason == idSeason})
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
    
    
    private func getGoalsData() -> [PlayerStat] {
        let goalsArray = statData.sorted {
            if $0.goals == $1.goals {
                return $0.name < $1.name
            } else {
                return $0.goals ?? 0 > $1.goals ?? 0
            }
        }.filter { $0.goals != nil}
        return goalsArray
        
    }
    
    
    private func getAssistData() -> [PlayerStat] {
        let assistArray = statData.sorted {
            if $0.assist == $1.assist {
                return $0.name < $1.name
            } else {
                return $0.assist ?? 0 > $1.assist ?? 0
            }
        }.filter { $0.assist != nil}
        return assistArray
    }
    
    private func update() {
        statData = getStatData()
        sortedGoalsTableData = getGoalsData()
        sortedAssistTableData = getAssistData()
        
    }
    
    // MARK: - Actions
    
    @objc func seeAllGoleadorsButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.seeAllGoleadorsButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.seeAllGoleadorsButton.transform = .identity
            }
        }
        let goals = sortedGoalsTableData
        let vc = ResultsActionsListViewController(dataForTableView: .goals(array: goals) )
        
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    @objc func seeAllPassesButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.seeAllGoleadorsButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.seeAllGoleadorsButton.transform = .identity
            }
        }
        
        let assist = sortedAssistTableData
        let vc = ResultsActionsListViewController(dataForTableView: .assist(array: assist) )
        
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Binding
    
    private func binding() {
        seasonTableImage.getImage(url: statisticsTeam.imageUrl) { imageSize in
            if let imageSize = imageSize {
                DispatchQueue.main.async {
                    self.seasonTableImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                }
            }
        }
        
        createBlueViewWithLabels(text1: statisticsTeam.games, text2: "Игр", in: statisticsUpperStackView)
        createBlueViewWithLabels(text1: statisticsTeam.balls, text2: "Мячи", in: statisticsUpperStackView)
        createBlueViewWithLabels(text1: statisticsTeam.points, text2: "Очки", in: statisticsUpperStackView)
        createBlueViewWithLabels(text1: statisticsTeam.wins, text2: "Побед", in: statisticsLowerStackView)
        createBlueViewWithLabels(text1: statisticsTeam.draw, text2: "Ничьи", in: statisticsLowerStackView)
        createBlueViewWithLabels(text1: statisticsTeam.loss, text2: "Поражений", in: statisticsLowerStackView)
    }
    
    private func createBlueViewWithLabels(text1: String, text2: String, in stackView: UIStackView) {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        let label1 = UILabel()
        label1.text = text1
        label1.textColor = .black
        label1.font = .boldSystemFont(ofSize: 20)
        
        let label2 = UILabel()
        label2.text = text2
        label2.textColor = .systemGray
        label2.font = .boldSystemFont(ofSize: 14)
        
        let labelsStackView = UIStackView(arrangedSubviews: [label1, label2])
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        labelsStackView.spacing = 2
        
        view.addSubview(labelsStackView)
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stackView.addArrangedSubview(view)
    }
    
    // MARK: - SetupUI
    
    private func createGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 86/255, green: 97/255, blue: 112/255, alpha: 1).cgColor,
            UIColor(red: 86/255, green: 97/255, blue: 112/255, alpha: 1).cgColor,
            UIColor.systemGray6.cgColor, UIColor.systemGray5.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.52)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(collectionViewContainer)
        collectionViewContainer.addSubview(collectionView)
        contentView.addSubview(tableNameLabel)
        
        contentView.addSubview(seasonTableImageContainer)
        seasonTableImageContainer.addSubview(seasonTableImage)
        
        contentView.addSubview(statsNameLabel)
        contentView.addSubview(matchesNameLabel)
        contentView.addSubview(goalsNameLabel)
        contentView.addSubview(goalsTableViewContainer)
        goalsTableViewContainer.addSubview(goalsTableView)
        
        contentView.addSubview(seeAllGoleadorsButton)
        contentView.addSubview(statisticsStackView)
        
        contentView.addSubview(passesNameLabel)
        
        contentView.addSubview(passesTableViewContainer)
        passesTableViewContainer.addSubview(passesTableView)
        
        contentView.addSubview(seeAllPassesButton)
        
        statisticsStackView.addArrangedSubview(statisticsUpperStackView)
        statisticsStackView.addArrangedSubview(statisticsLowerStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            tableNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            seasonTableImageContainer.topAnchor.constraint(equalTo: tableNameLabel.bottomAnchor, constant: 10),
            seasonTableImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            seasonTableImageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seasonTableImageContainer.heightAnchor.constraint(equalToConstant: 250),
            
            seasonTableImage.topAnchor.constraint(equalTo: seasonTableImageContainer.topAnchor),
            seasonTableImage.leadingAnchor.constraint(equalTo: seasonTableImageContainer.leadingAnchor),
            seasonTableImage.trailingAnchor.constraint(equalTo: seasonTableImageContainer.trailingAnchor),
            seasonTableImage.bottomAnchor.constraint(equalTo: seasonTableImageContainer.bottomAnchor),
            
            statsNameLabel.topAnchor.constraint(equalTo: seasonTableImage.bottomAnchor, constant: 15),
            statsNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            statisticsStackView.topAnchor.constraint(equalTo: statsNameLabel.bottomAnchor, constant: 10),
            statisticsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statisticsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statisticsStackView.heightAnchor.constraint(equalToConstant: 150),
            
            matchesNameLabel.topAnchor.constraint(equalTo: statisticsStackView.bottomAnchor, constant: 10),
            matchesNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            collectionViewContainer.topAnchor.constraint(equalTo: matchesNameLabel.bottomAnchor, constant: 10),
            collectionViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionViewContainer.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor),
            
            goalsNameLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            goalsNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            seeAllGoleadorsButton.bottomAnchor.constraint(equalTo: goalsTableView.topAnchor, constant: -10),
            seeAllGoleadorsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            seeAllGoleadorsButton.heightAnchor.constraint(equalToConstant: 10),
            seeAllGoleadorsButton.widthAnchor.constraint(equalToConstant: 30),
            
            goalsTableViewContainer.topAnchor.constraint(equalTo: goalsNameLabel.bottomAnchor, constant: 10),
            goalsTableViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            goalsTableViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            goalsTableViewContainer.heightAnchor.constraint(equalToConstant: 166),
            
            goalsTableView.topAnchor.constraint(equalTo: goalsTableViewContainer.topAnchor),
            goalsTableView.leadingAnchor.constraint(equalTo: goalsTableViewContainer.leadingAnchor),
            goalsTableView.trailingAnchor.constraint(equalTo: goalsTableViewContainer.trailingAnchor),
            goalsTableView.bottomAnchor.constraint(equalTo: goalsTableViewContainer.bottomAnchor),
            
            passesNameLabel.topAnchor.constraint(equalTo: goalsTableView.bottomAnchor, constant: 10),
            passesNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            seeAllPassesButton.bottomAnchor.constraint(equalTo: passesTableView.topAnchor, constant: -10),
            seeAllPassesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            seeAllPassesButton.heightAnchor.constraint(equalToConstant: 10),
            seeAllPassesButton.widthAnchor.constraint(equalToConstant: 30),
            
            passesTableViewContainer.topAnchor.constraint(equalTo: passesNameLabel.bottomAnchor, constant: 10),
            passesTableViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passesTableViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passesTableViewContainer.heightAnchor.constraint(equalToConstant: 166),
            
            passesTableView.topAnchor.constraint(equalTo: passesTableViewContainer.topAnchor),
            passesTableView.leadingAnchor.constraint(equalTo: passesTableViewContainer.leadingAnchor),
            passesTableView.trailingAnchor.constraint(equalTo: passesTableViewContainer.trailingAnchor),
            passesTableView.bottomAnchor.constraint(equalTo: passesTableViewContainer.bottomAnchor),
            
            passesTableViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - SetupCollectionView

extension MatchesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredMatches = matches.filter({$0.idSeason == idSeason})
        return filteredMatches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchViewCell.identifier, for: indexPath) as? MatchViewCell else { return UICollectionViewCell() }
        let match = filteredMatches[indexPath.item]
        cell.configure(match: match)
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 220, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = filteredMatches[indexPath.item]
        let vc = MatchCenterViewController(match: match, players: players)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - SetupTableView

extension MatchesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == goalsTableView {
            return min(sortedGoalsTableData.count, 3)
        } else {
            return min(sortedAssistTableData.count, 3)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        if !sortedGoalsTableData.isEmpty, !sortedAssistTableData.isEmpty {
            if tableView == goalsTableView {
                let player = sortedGoalsTableData[indexPath.row]
                cell.configure(name: player.name, image: player.image ?? "", number: player.goals ?? 0)
                cell.numberLabel.text = "\(indexPath.row + 1)"
                
            } else {
                let player = sortedAssistTableData[indexPath.row]
                cell.configure(name: player.name, image: player.image ?? "", number: player.assist ?? 0)
                cell.numberLabel.text = "\(indexPath.row + 1)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !sortedGoalsTableData.isEmpty, !sortedAssistTableData.isEmpty {
            if tableView == goalsTableView {
                let playerStat = sortedGoalsTableData[indexPath.row]
                let vc = PlayerDetailViewController(playersStat: playerStat)
                
                if let navigationController = navigationController {
                    navigationController.pushViewController(vc, animated: true)
                }
            } else {
                let playerStat = sortedAssistTableData[indexPath.row]
                
                let vc = PlayerDetailViewController(playersStat: playerStat)
                
                if let navigationController = navigationController {
                    navigationController.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == goalsTableView {
            let labels = ["№", "Игрок", "Голы"]
            let headerView = TableSectionHeaderView(labels: labels)
            return headerView
        } else {
            let labels = ["№", "Игрок", "Пасы"]
            let headerView = TableSectionHeaderView(labels: labels)
            return headerView
        }
    }
}




