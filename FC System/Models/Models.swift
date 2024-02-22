//
//  Models.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import Foundation
import UIKit

struct Match: Decodable, WebViewContentProtocol {
    let assistPlayers: [String]
    let dateMatch: String
    let goalsPlayers: [String]
    let idSeason: String
    let opponentName: String
    let score: String
    let squad: [String]
    let systemName: String
    let timeMatch: String
    let tourNumber: String
    let tournamentName: String
    let url: String
}

struct Player: Decodable {
    let assistInSeason: String?
    let descriptionPlayer: String?
    let gamesInSeason: String?
    let goalsInSeason: String?
    let id: String
    let image: String?
    let name: String
    let position: String
    let totalAssists: String?
    let totalGames: String?
    let totalGoals: String?
    let zeroGameGk: String?
}

struct News: Decodable, WebViewContentProtocol {    
    let date: String
    let image: String
    let text: String
    let title: String
    let url: String
}

struct StatisticsTeam: Decodable {
    let balls: String
    let draw: String
    let games: String
    let iconName: String
    let idSeason: String
    let imageUrl: String
    let loss: String
    let nameSeason: String
    let points: String
    let wins: String
}

struct CurrentSeason: Decodable {
    let idSeason: String
}


struct About {
    let imageName: String
    let description: String
    let color: UIColor
    let isSetup: Bool
}

struct SetupApp: Decodable {
    let urlRateApp: String
    let versionApp: String
}

struct PlayerStat {
    let name: String
    let image: String?
    let goals: Int?
    let games: Int?
    let assist: Int?
    let gatesZero: String?
    let position: String
    let descriptionPlayer: String?
}


