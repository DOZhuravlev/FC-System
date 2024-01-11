//
//  MoreViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class MoreViewController: UITableViewController {

    let names = ["О клубе", "Поле для тренировок", "Стадион для игр", "Тех. поддержка", "Настройки", "Оценить приложение"]

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



    // MARK: - Navigation


}

