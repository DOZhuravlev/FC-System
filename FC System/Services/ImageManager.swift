//
//  ImageManager.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 13.01.2024.
//

import Foundation

final class ImageManager {

    static let shared = ImageManager()

    private init() {}

    func getImage(imageUrl: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            guard imageUrl == response.url else { return }

            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
}
