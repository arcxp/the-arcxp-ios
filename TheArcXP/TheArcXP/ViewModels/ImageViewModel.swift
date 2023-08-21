//
//  ImageViewModel.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 7/15/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded(UIImage)
    }
    
    @Published private(set) var state = State.idle
    
    private let imageUrlString: String
    private let imageLoader: ImageLoader
    
    init(url: String, loader: ImageLoader) {
        self.imageUrlString = url
        self.imageLoader = loader
    }
    
    func load() {
        state = .loading
        
        imageLoader.loadImage(with: imageUrlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.state = .loaded(image)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
