//
//  FirestoreService.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 12.01.2024.
//

import Firebase
import FirebaseFirestore

enum DataStructureType {
    case matches
    case players
    case news
    case statistics
    case currentSeason
    case topNews
    case setupApp
}

final class FirestoreService {

    static let shared = FirestoreService()
    private init() {}
    let db = Firestore.firestore()

    func fetchItems<T: Decodable>(for type: DataStructureType, completion: @escaping (Result<[T], Error>) -> Void) {

        var collectionReference: CollectionReference

        switch type {
        case .matches:
            collectionReference = db.collection("matches")
        case .players:
            collectionReference = db.collection("players")
        case .news:
            collectionReference = db.collection("news")
        case .statistics:
            collectionReference = db.collection("statistics")
        case .currentSeason:
            collectionReference = db.collection("currentSeason")
        case .topNews:
            collectionReference = db.collection("topNews")
        case .setupApp:
            collectionReference = db.collection("setupApp")
        }

        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                if let documents = snapshot?.documents {
                    do {
                        let items = try documents.compactMap { document in
                            try document.data(as: T.self)
                        }
                        DispatchQueue.main.async {
                            completion(.success(items))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                }
            }
        }
    }
}
