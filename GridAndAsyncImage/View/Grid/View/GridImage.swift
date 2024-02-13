//
//  GridImage.swift
//  GridAndAsyncImage
//
//  Created by Naela Fauzul Muna on 12/02/24.
//

import SwiftUI

struct GridImage: View {
    @StateObject private var photoVM = PhotosViewModel()
    @State private var confirmationShow = false
    @State private var indexPhoto = 0
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    var filteredPhotos: [Photo] {
        if searchText.isEmpty {
            return photoVM.photos
        } else {
            return photoVM.photos.filter { photo in
                photo.name.contains(searchText) ||
                photo.anime.contains(searchText)
            }
        }
    }
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]
    
    var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(filteredPhotos) { photo in
                        Group {
                            let url = URL(string: photo.image)
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    waitView()
                                    
                                case .success(let image):
                                    VStack(alignment: .leading) {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                        Text(photo.name)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .foregroundColor(.black)
                                        
                                        Text(photo.anime)
                                            .font(.caption)
                                            .lineLimit(2)
                                        
                                    }
                                    
                                case .failure(let error):
                                    VStack(alignment: .leading) {
                                        Image(systemName: "photo.fill")
                                            .frame(width: 100, height: 100)
                                            .background(.blue)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        Text(photo.name)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .foregroundColor(.black)
                                        
                                        Text(photo.anime)
                                            .font(.caption)
                                            .lineLimit(2)
                                    }
                                    
                                    
                                @unknown default:
                                    fatalError()
                                }
                            }
                            .padding()
                    
                        }
                        .frame(width: 100, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .sheet(isPresented: $photoVM.showOptions) {
                            Group {
                                let defaultText = "You are about to share this items"
                                
                                if let imageToShare = photoVM.imageToShare {
                                    ActivityView(activityItems: [defaultText, imageToShare])
                                } else {
                                    ActivityView(activityItems: [defaultText])
                                }
                            }
                            .presentationDetents([.medium, .large])
                        }
                        .contextMenu {
                            Button {
                                Task {
                                    await photoVM.prepareImageAndShowSheet(from: photo.image)
                                }
                                
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            
                            Button {
                                if let index = self.photoVM.photos.firstIndex(of: photo) {
                                    indexPhoto = index
                                }
                                confirmationShow = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .confirmationDialog("Are you sure?", isPresented: $confirmationShow, titleVisibility: .visible
                        ) {
                            Button("Yes", role: .destructive, action: {
                                self.photoVM.photos.remove(at: indexPhoto)
                            })
                            Button("Cancel", role: .cancel, action: {})
                        }
                    }
                }
                .padding()
            }
        }
        .searchable(text: $searchText, isPresented: $searchIsActive)
        .task {
            await photoVM.fetchPhotos()
        }
    }
    
}

#Preview {
    GridImage()
}

