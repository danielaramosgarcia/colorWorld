//
//  GalleryView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 17/02/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct GalleryView: View {

    @Query(sort: \SampleModel.name) var samples: [SampleModel]
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 3)

    var body: some View {
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - 95) / 3

        if let selectedIndex = selectedCard, samples.indices.contains(selectedIndex) {
            VStack {
                ColorCard(
                    card: samples[selectedIndex],
                    width: 300, // Tamaño grande
                    height: 400,
                    selectedCard: $selectedCard,
                    selectedModel: $selectedModel
                )
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedCard = nil
                        selectedModel = nil
                    }
                }
                .scaleEffect(1.6)
                .shadow(radius: 10)
            }
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    if samples.count > 0 {

                    ForEach(Array(samples.enumerated()), id: \.element.id) { index, sample in
                        ColorCard(
                            card: sample,
                            width: cellWidth,
                            height: cellWidth,
                            selectedCard: $selectedCard,
                            selectedModel: $selectedModel
                        )
                        .opacity(selectedCard == nil ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedCard = index
                                selectedModel = sample
                            }
                        }
                    }
                } else {
                        let noCardsImage = UIImage(named: "noCards")
                        let noCardsData = noCardsImage!.jpegData(compressionQuality: 1.0)
                        let sample = SampleModel(id: UUID(), name: "No cards yet", data: noCardsData)
                    ColorCard(
                        card: sample,
                        width: cellWidth,
                        height: cellWidth,
                        selectedCard: $selectedCard,
                        selectedModel: $selectedModel
                    )
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    HomepageView()
        .modelContainer(SampleModel.preview)
}
