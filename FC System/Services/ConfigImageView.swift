//
//  ConfigImageView.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 13.01.2024.
//

import Foundation
import UIKit

final class ConfigImageView: UIImageView {
    func getImage(url: String, completion: @escaping (CGSize?) -> Void) {
        guard let url = URL(string: url) else {
            image = UIImage(named: ImageNames.blankImage)
            completion(nil)
            return
        }

        if let cachedImage = getCachedImage(from: url) {
            image = cachedImage
            return
        }

        ImageManager.shared.getImage(imageUrl: url) { data, response in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion(self.intrinsicContentSize)
            }
            self.saveDataToCache(with: data, and: response)
        }
    }

    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }

    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}


