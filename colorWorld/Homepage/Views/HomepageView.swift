//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI

struct HomepageView: View {
    @StateObject private var model = DataModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()
                    .background()
                VStack {
                    Spacer()

                    Text("ColorWorld")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .blue, .green, .yellow]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .blur(radius: 5)
                        .overlay(
                            Text("ColorWorld")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                        )
                    Spacer()
                    CardDeck(deck: CardDeckModel.demoDeck)
                    Spacer()
                    HStack {
                        NavigationLink {
                            PhotoCollectionView(photoCollection: model.photoCollection)
                                .onAppear {
                                    model.camera.isPreviewPaused = true
                                }
                                .onDisappear {
                                    model.camera.isPreviewPaused = false
                                }
                        } label: {
                            VStack(spacing: 10) { // Stack vertically with some spacing
                                ThumbnailView(image: model.thumbnailImage, size: 60)
                                Text("Gallery")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                            .padding( .top, 20) // Add horizontal padding
                            .offset(x: -30)
                        }

                        NavigationLink(destination: CameraView()) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Add Photo")
                                    .font(.title)
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors:
                                            [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                                    )
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                        }
                    }
                    Spacer()

                }
            }
        }
        .task {
            await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
    }
    }

#Preview {
    HomepageView()
}
