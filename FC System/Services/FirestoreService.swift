//
//  FirestoreService.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 12.01.2024.
//

import Firebase
import FirebaseFirestore

final class FirestoreService {

    static let shared = FirestoreService()

    private init() {}

    let db = Firestore.firestore()

    private var coachesRef: CollectionReference {
        return db.collection("players/coaches/coaches")
    }

    private var goalkeepersRef: CollectionReference {
        return db.collection("players/coaches/goalkeepers")
    }

    private var defendersRef: CollectionReference {
        return db.collection("players/coaches/defenders")
    }

    private var midfieldersRef: CollectionReference {
        return db.collection("players/coaches/midfielders")
    }

    private var forwardsRef: CollectionReference {
        return db.collection("players/coaches/forwards")
    }

    func getPlayersData(completion: @escaping (Result<([MockUser], [MockUser], [MockUser], [MockUser], [MockUser]), Error>) -> Void) {

        var coaches: [MockUser] = []
        var goalkeepers: [MockUser] = []
        var defenders: [MockUser] = []
        var midfielders: [MockUser] = []
        var forwards: [MockUser] = []

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        coachesRef.getDocuments { snapShot, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapShot?.documents {
                    do {
                        coaches = try documents.compactMap { document in
                            try document.data(as: MockUser.self)
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }

        dispatchGroup.enter()
        goalkeepersRef.getDocuments { snapShot, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapShot?.documents {
                    do {
                        goalkeepers = try documents.compactMap { document in
                            try document.data(as: MockUser.self)
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }

        dispatchGroup.enter()
        defendersRef.getDocuments { snapShot, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapShot?.documents {
                    do {
                        defenders = try documents.compactMap { document in
                            try document.data(as: MockUser.self)
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }

        dispatchGroup.enter()
        midfieldersRef.getDocuments { snapShot, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapShot?.documents {
                    do {
                        midfielders = try documents.compactMap { document in
                            try document.data(as: MockUser.self)
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }

        dispatchGroup.enter()
        forwardsRef.getDocuments { snapShot, error in
            defer {
                dispatchGroup.leave()
            }
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapShot?.documents {
                    do {
                        forwards = try documents.compactMap { document in
                            try document.data(as: MockUser.self)
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success((coaches, goalkeepers, defenders, midfielders, forwards)))
        }
    }
}
