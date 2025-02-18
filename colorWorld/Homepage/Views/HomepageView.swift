//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//
import SwiftUI
import _SwiftData_SwiftUI

struct HomepageView: View {
    @State private var selectedCard: Int?
    @State private var selectedCardModel: SampleModel?
    @State private var path: [Data] = []
    @State private var selectedModel: SampleModel?
    @State private var selectedData: Data = Data()
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()
                VStack {
                    HStack {
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
                            .padding(.top, 20)

                        Spacer()

                        if selectedCard == nil {
                            Button(action: {
                                print("hola")
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 60)
                    Spacer()

                    HStack(spacing: 15) {
                        tabButton(title: "Recents", image: "clock", tag: 0)
                        tabButton(title: "Gallery", image: "photo", tag: 1)
                        tabButton(title: "Details", image: "info.circle", tag: 2)
                    }
                    .padding(.top, 20)

                    TabView(selection: $selectedTab) {
                        LoopingStack(selectedCard: $selectedCard, selectedModel: $selectedModel)
                            .tag(0)
                        GalleryView(selectedCard: $selectedCard, selectedModel: $selectedModel)
                            .tag(1)
                        ListView(selectedCard: $selectedCard, selectedModel: $selectedModel)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 700)
                    Spacer()
                    Buttons(selectedCard: $selectedCard,
                            selectedData: $selectedData,
                            path: $path,
                            selectedModel: $selectedModel)
                }
            }
            .navigationDestination(for: Data.self) { selectedImage in
                SelectedImage(image: selectedImage)
            }
        }
    }

    private func tabButton(title: String, image: String, tag: Int) -> some View {
        Button(action: { selectedTab = tag }) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                Image(systemName: image)
                    .font(.system(size: 24))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .foregroundColor(selectedTab == tag ? .blue : .white)
            .background(
                selectedTab == tag ?
                Color.white.opacity(0.3) :
                Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
    }
}

#Preview {
    HomepageView()
        .modelContainer(SampleModel.preview)
}
