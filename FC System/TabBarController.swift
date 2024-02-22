//
//  TabBarController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit


final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBarController()
        setupTabBarViewController()
    }

    private func setupTabBarController() {
        tabBar.tintColor = .systemBlue
        tabBar.barTintColor = .systemGray5
        tabBar.backgroundColor = .systemGray5
        tabBar.isTranslucent = false
    }

    private func setupTabBarViewController() {
        let first = MainViewController()
        let firstIcon = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        first.tabBarItem = firstIcon

        let second = SeasonsViewController()
        let secondIcon = UITabBarItem(title: "Турнир", image: UIImage(systemName: "trophy"), selectedImage: UIImage(systemName: "trophy.fill"))
        second.tabBarItem = secondIcon

        let third = PlayersListViewController()
        let thirdIcon = UITabBarItem(title: "Команда", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
        third.tabBarItem = thirdIcon

        let fourth = TheoryViewController()
        let fourthIcon = UITabBarItem(title: "Теория", image: UIImage(systemName: "sportscourt"), selectedImage: UIImage(systemName: "sportscourt.fill"))
        fourth.tabBarItem = fourthIcon

        let fifth = MoreViewController()
        let fifthIcon = UITabBarItem(title: "Еще", image: UIImage(systemName: "ellipsis.rectangle"), selectedImage: UIImage(systemName: "ellipsis.rectangle.fill"))
        fifth.tabBarItem = fifthIcon

        let controllers = [first, second, third, fourth, fifth]
        self.setViewControllers(controllers, animated: true)
    }
}

