//
//  ImageView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/6/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @StateObject var viewModel: ImageViewModel
    var filename: String?
    
    init(withURL urlString: String?, withFilename filename: String? = nil) {
        _viewModel = StateObject(wrappedValue: ImageViewModel(url: urlString ?? "", loader: ImageLoader()))
        self.filename = filename
    }
    
    var body: some View {
        if let filename = filename {
            Image(filename)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear {
                    viewModel.load()
                }
            case .loading:
                ProgressView()
            case .failed:
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
