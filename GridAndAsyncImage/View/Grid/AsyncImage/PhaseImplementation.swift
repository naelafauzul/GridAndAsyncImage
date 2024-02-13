//
//  PhaseImplementation.swift
//  GridAndAsyncImage
//
//  Created by Naela Fauzul Muna on 12/02/24.
//

import SwiftUI

struct PhaseImplementation: View {
    let imageUrl = URL(string: "https://res.cloudinary.com/moyadev/image/upload/v1701927368/LKA_h6qbro.jpg")!
    
    let transition = Transaction(animation: .easeInOut(duration: 2.5))
    
    
    var body: some View {
        AsyncImage(url: imageUrl, transaction: transition) { phase in
            switch phase {
            case .empty:
                waitView()
                
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding()
                
            case .failure( _):
                Text("Couldn't load image")
                
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    PhaseImplementation()
}

@ViewBuilder
func waitView() -> some View {
    VStack(spacing: 20) {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.pink)
        
        Text("fetching image....")
    }
}
