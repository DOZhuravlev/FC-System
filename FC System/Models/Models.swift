//
//  Models.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation

enum Position: String {
    case goalkeeper = "Вратарь"
    case defender = "Защитник"
    case midfielder = "Полузащитник"
    case forward = "Нападающий"
    case coach = "Тренер"
}

struct Season {
    let name: String
    let image: String
    let match: [Match]
}

struct MockUser: Decodable {
    let name: String
}



struct Player {
    let name: String
    let image: String
    let birthdayDate: String
    let position: Position
    let aboutPlayer: String
    let mvpMonth: String
    let goalsInSeason: Int
    let passesInSeason: Int

    static func getPlayers() -> [[Player]] {
        [
            [
                Player(name: "Antonio Huan", image: "1", birthdayDate: "01.01.2020", position: .coach, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Marson Geel", image: "2", birthdayDate: "01.01.2020", position: .coach, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
            ],
            [
                Player(name: "Antonio Huan", image: "3", birthdayDate: "01.01.2020", position: .goalkeeper, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
            ],
            [
                Player(name: "Antonio Huan", image: "1", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Marson Geel", image: "2", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Rusty Bound", image: "3", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Klerk Bradly", image: "4", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Augusto Demov", image: "5", birthdayDate: "01.01.2020", position: .defender, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
            ],
            [
                Player(name: "Antonio Huan", image: "1", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Marson Geel", image: "2", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Rusty Bound", image: "3", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Klerk Bradly", image: "4", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Augusto Demov", image: "5", birthdayDate: "01.01.2020", position: .midfielder, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
            ],
            [
                Player(name: "Antonio Huan", image: "1", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Marson Geel", image: "2", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Rusty Bound", image: "3", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Klerk Bradly", image: "4", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1),
                Player(name: "Augusto Demov", image: "5", birthdayDate: "01.01.2020", position: .forward, aboutPlayer: "Хороший Игрок", mvpMonth: "1", goalsInSeason: 1, passesInSeason: 1)
            ]
        ]
    }
}

struct Team {
    let position: Position
    let player: Player
}


struct Match {
    let seasonName: String
    let tourName: String
    let tournamentImage: String
    let tournamentTable: String
    let systemaTeamName: String
    let rivalTeamName: String
    let scoreMatch: String
    let goalsPlayersInMatch: [String]
    let passesPlayersInMatch: [String]
    let squadOnGame: [String]
    let dateMatch: String
    let timeMatch: String

}
