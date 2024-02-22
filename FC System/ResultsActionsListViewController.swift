//
//  ResultsActionsListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 26.01.2024.
//

import Foundation
import UIKit

final class ResultsActionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    let dataForTableView: ResultsAction

    // MARK: - Outlets

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
        return table
    }()

    // MARK: - Initializers

    init(dataForTableView: ResultsAction) {
        self.dataForTableView = dataForTableView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        switch dataForTableView {
        case .goals(_):
            title = "Бомбардиры команды"
        case .assist(_):
            title = "Ассистенты команды"
        }
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

    }

    // MARK: - SetupTableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataForTableView {
        case .goals(let array):
            return array.count
        case .assist(let array):
            return array.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        switch dataForTableView {
        case .goals(let array):
            let player = array[indexPath.row]
            cell.configure(name: player.name, image: player.image ?? "", number: player.goals ?? 0)
            cell.numberLabel.text = "\(indexPath.row + 1)"
        case .assist(let array):
            let player = array[indexPath.row]
            cell.configure(name: player.name, image: player.image ?? "", number: player.assist ?? 0)
            cell.numberLabel.text = "\(indexPath.row + 1)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataForTableView {
        case .goals(_):
            let labels = ["№", "Игрок", "Голы"]
            let headerView = TableSectionHeaderView(labels: labels)
            return headerView
        case .assist(_):
            let labels = ["№", "Игрок", "Пасы"]
            let headerView = TableSectionHeaderView(labels: labels)
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataForTableView {
        case .goals(let array):
            let playerStat = array[indexPath.row]
            let vc = PlayerDetailViewController(playersStat: playerStat)
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        case .assist(let array):
            let playerStat = array[indexPath.row]
            let vc = PlayerDetailViewController(playersStat: playerStat)
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
}
