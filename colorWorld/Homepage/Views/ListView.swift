//
//  ListView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 17/02/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ListView: View {
    @Query(sort: \SampleModel.name) var samples: [SampleModel]
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    var body: some View {
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
                List {
                    if samples.count > 0 {
                    ForEach(Array(samples.enumerated()), id: \.element.id) { index, sample in
                        HStack(spacing: 15) {
                            if let uiImage = sample.img {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(8)
                            } else {
                                Color.gray
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            }
                            Text(sample.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
                        .opacity(selectedCard == nil ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedCard = index
                                selectedModel = sample
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
                        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .listRowSeparator(.hidden)
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color.clear)
                    }
                } else {
                    HStack(spacing: 15) {
                            Image("noCards")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(8)

                        Text("No cards yet")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
                    .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.clear)
                }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 40)
                .padding(.top, 30)
        }
    }
}

#Preview {
    HomepageView()
        .modelContainer(SampleModel.preview)
}
