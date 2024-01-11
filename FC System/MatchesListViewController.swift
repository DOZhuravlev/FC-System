//
//  MatchesListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class MatchesListViewController: UIViewController {

    var matches = [ Season(name: "ВИЗ Зима 2023",
                           image: "stad1",
                           match: [
                            Match(seasonName: "Виз 2023 - Лето", tourName: "1 тур", tournamentImage: "1", tournamentTable: "", systemaTeamName: "ФА Система", rivalTeamName: "City Centr", scoreMatch: "-:-", goalsPlayersInMatch: ["KUKA", "EGOR"], passesPlayersInMatch: ["KUKA"], squadOnGame: ["KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "KUKA"], dateMatch: "11 апреля 2023г.", timeMatch: "22-00"),
                            Match(seasonName: "Виз 2023 - Лето", tourName: "2 тур", tournamentImage: "2", tournamentTable: "", systemaTeamName: "FC SYSMEMA", rivalTeamName: "MACAN", scoreMatch: "5-1", goalsPlayersInMatch: ["KUKA", "EGOR"], passesPlayersInMatch: ["KUKA"], squadOnGame: ["KUKA", "KUKA", "KUKA", "KUKA", "KUKA", "EGOR", "EGOR", "EGOR", "EGOR", "EGOR"], dateMatch: "11 апреля 2023г.", timeMatch: "22-00"),
                            Match(seasonName: "Виз 2023 - Лето", tourName: "3 тур", tournamentImage: "3", tournamentTable: "1", systemaTeamName: "FC SYSMEMA", rivalTeamName: "NEOLIFE", scoreMatch: "2-1", goalsPlayersInMatch: ["Armen", "EGOR"], passesPlayersInMatch: ["Armen"], squadOnGame: ["KUKA", "Armen", "KUKA", "Armen", "KUKA", "EGOR", "EGOR", "Armen", "EGOR", "Armen"], dateMatch: "11 апреля 2023г.", timeMatch: "22-00")
                           ]),

                    Season(name: "ВИЗ Лето 2023",
                           image: "stad2",
                           match: [
                            Match(seasonName: "Виз 2023 - Лето", tourName: "5 тур", tournamentImage: "3", tournamentTable: "1", systemaTeamName: "FC SYSMEMA", rivalTeamName: "NEOLIFE", scoreMatch: "2-1", goalsPlayersInMatch: ["Armen", "EGOR"], passesPlayersInMatch: ["Armen"], squadOnGame: ["KUKA", "Armen", "KUKA", "Armen", "KUKA", "EGOR", "EGOR", "Armen", "EGOR", "Armen"], dateMatch: "11 апреля 2023г.", timeMatch: "22-00"),
                            Match(seasonName: "Виз 2023 - Лето", tourName: "4 тур", tournamentImage: "3", tournamentTable: "1", systemaTeamName: "FC SYSMEMA", rivalTeamName: "NEOLIFE", scoreMatch: "2-1", goalsPlayersInMatch: ["Armen", "EGOR"], passesPlayersInMatch: ["Armen"], squadOnGame: ["KUKA", "Armen", "KUKA", "Armen", "KUKA", "EGOR", "EGOR", "Armen", "EGOR", "Armen"], dateMatch: "11 апреля 2023г.", timeMatch: "22-00")

                           ])
                    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: MatchViewCell.identifier)

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .gray
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView

    }()

    private var seasonTableImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = true
        image.layer.shadowColor = UIColor.systemPink.cgColor
        image.layer.shadowOpacity = 0.8
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 10
        image.layer.shouldRasterize = true
        image.layer.rasterizationScale = UIScreen.main.scale

        return image


    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        seasonTableImage.image = UIImage(named: "table1")
        seasonTableImage.frame = CGRect(x: 0, y: 200, width: 400, height: 220)
        collectionView.frame = CGRect(x: 0, y: 500, width: 400, height: 220)

        view.addSubview(collectionView)
        view.addSubview(seasonTableImage)

        view.backgroundColor = .gray
    }




}

extension MatchesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }



    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchViewCell.identifier, for: indexPath) as? MatchViewCell

        guard let matchViewCell = cell else { return UICollectionViewCell() }

        guard let match = matches[indexPath.row].match.first else { return UICollectionViewCell() }

        matchViewCell.setupCell(imageMatch: UIImage(named: match.tournamentImage), nameMatch: match.seasonName, tour: match.tourName, systemaName: match.systemaTeamName, rivalName: match.rivalTeamName, score: match.scoreMatch, date: match.dateMatch, time: match.timeMatch)

//        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
//
//        matchViewCell.viewModel = cellViewModel

        return matchViewCell
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



}
