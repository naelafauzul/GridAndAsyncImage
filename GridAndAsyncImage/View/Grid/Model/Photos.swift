//
//  Photos.swift
//  GridAndAsyncImage
//
//  Created by Naela Fauzul Muna on 13/02/24.
//

import Foundation

struct Photo: Identifiable, Decodable, Equatable {
    let id = UUID()
    let image: String
    let anime: String
    let name: String
    
}
