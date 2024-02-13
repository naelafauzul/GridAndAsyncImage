//
//  PhotosViewModel.swift
//  GridAndAsyncImage
//
//  Created by Naela Fauzul Muna on 13/02/24.
//

import SwiftUI

@MainActor
class PhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var imageToShare: UIImage?
    @Published var showOptions: Bool = false
    
    func fetchPhotos() async {
        do {
            let loadedPhotos = try await loadPhotos()
            self.photos = loadedPhotos
            
        } catch {
            print(error)
        }
    }
    
    private func loadPhotos() async throws -> [Photo] {
        //1: Validasi URL
        guard let photosURL = URL(string: "https://waifu-generator.vercel.app/api/v1") else {
            throw URLError(.badURL)
        }
        
        //2: Data
        let (data, _) = try await URLSession.shared.data(from: photosURL)
        
        //3: Decode Data
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        return photos
    }
    
    // Download
    func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    // Prepare untuk muncul di sheet
    func prepareImageAndShowSheet(from urlString: String) async {
        imageToShare = await downloadImage(from: urlString)
        showOptions = true
        
    }
    
    func deletePhoto(at index: Int) {
            photos.remove(at: index)
        }
    
}
