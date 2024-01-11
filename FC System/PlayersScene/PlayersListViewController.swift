//
//  PlayersListViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

final class PlayersListViewController: UIViewController {


    var players =
        [
            Player(name: "Antonio Huan", image: "1", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
            Player(name: "Marson Geel", image: "2", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
            Player(name: "Rusty Bound", image: "3", birthdayDate: "01.01.2020", position: .coach, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
            Player(name: "Klerk Bradly", image: "4", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
            Player(name: "Augusto Demov", image: "5", birthdayDate: "01.01.2020", position: .goalkeeper, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
        ]

    //MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(PlayerViewCell.self, forCellWithReuseIdentifier: PlayerViewCell.identifier)
        collectionView.register(PlayersCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayersCellHeader.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .gray
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.frame = view.bounds
        setupHierarchy()
       // setupLayout()
    }

    //MARK: - Setup

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
}

extension PlayersListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        players.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerViewCell.identifier, for: indexPath) as? PlayerViewCell

        guard let playerViewCell = cell else { return UICollectionViewCell() }

        playerViewCell.setupCell(imagePlayer: (UIImage(named: players[indexPath.item].image) ?? nil), namePlayer: players[indexPath.item].name)

//        playerViewCell.image.image = UIImage(named: players[indexPath.item].image) ?? nil
//        playerViewCell.label.text = players[indexPath.item].name


        return playerViewCell

    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlowLayoutCell.identifier, for: indexPath)
//
//
//        return cell
//
//    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayersCellHeader.identifier, for: indexPath) as! PlayersCellHeader
        header.title.text = "ПОЛУЗАЩИТНИКИ"

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 20)
    }

    // TODO: - выбор ячейки
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let viewModel = viewModel else { return }
//        viewModel.selectedItem(atIndexPath: indexPath)
//
//        let vc = PlayerDetailViewController()
//        vc.viewModel = viewModel.viewModelForSelectedItem()
//
//        present(vc, animated: true)
//    }
// TODO: - доработать метод перехода на детейел
//    override func show(_ vc: UIViewController, sender: Any?) {
//        guard let viewModel = viewModel else { return }
//
//        var vc = PlayerDetailViewController()
//        vc.viewModel = viewModel.viewModelForSelectedItem()
//
//
//    }





}
