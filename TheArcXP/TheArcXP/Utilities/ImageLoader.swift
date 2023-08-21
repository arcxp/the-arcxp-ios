//
//  ImageLoader.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/6/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import SwiftUI

class ImageLoader {
    private var imageCache: ImageCache = Environment(\.imageCache).wrappedValue
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    enum ImageLoadingError: Error {
        case loadingError
        case nilImageValue
    }
    
    func loadImage(with urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageLoadingError.loadingError))
            return
        }
        
        if let cachedImage = imageCache[url] {
            completion(.success(cachedImage))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if error != nil {
                completion(.failure(ImageLoadingError.loadingError))
            }
            
            guard let imageData = data else { return }
            
            self?.cache(UIImage(data: imageData), urlString: urlString)
            
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData) {
                    completion(.success(image))
                } else {
                    completion(.failure(ImageLoadingError.nilImageValue))
                }
            }
        }.resume()
    }
    
    private func cache(_ image: UIImage?, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image.map { imageCache[url] = $0 }
    }
}
