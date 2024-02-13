//
//  BasicImplementation.swift
//  GridAndAsyncImage
//
//  Created by Naela Fauzul Muna on 12/02/24.
//

import SwiftUI

struct BasicImplementation: View {
    let imageUrl = URL(string: "https://res.cloudinary.com/moyadev/image/upload/v1695820488/sena/anime-notion-icon1_gxmcel.png")!
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } placeholder: {
            LoadingView()
        }
    }
}

#Preview {
    BasicImplementation()
}

struct LoadingView: View {
    var body: some View {
        HStack {
            Label("Loading...", systemImage: "clock")
                .foregroundStyle(.white)
        }
        .frame(width: 200, height: 200)
        .background(.red)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}
