//
//  SeasonsViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 12.01.2024.
//

import Foundation
import UIKit

final class SeasonsViewController: UITableViewController {

    let names = ["Зима 2024", "Осень 2023", "Лето 2023", "Весна 2023", "Зима 2023"]

    var cellIdetifier = "Cell"


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdetifier)

    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdetifier, for: indexPath)
        var content = cell.defaultContentConfiguration()

        let date = names[indexPath.row]
        content.text = date
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MatchesListViewController()
        //vc.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }



    // MARK: - Navigation


}

