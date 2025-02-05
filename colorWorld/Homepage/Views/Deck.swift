//
//  Deck.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/01/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct Deck: View {
    @Query(sort: \SampleModel.name) var samples: [SampleModel]
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    var body: some View {
//        NavigationStack {
            VStack {
                LoopingStack(maxTranslationWidth: 200, selectedCard: $selectedCard) {
                        ForEach(samples) { card in
                            ColorCard(card: card, selectedCard: $selectedCard, selectedModel: $selectedModel)

                                }
                        }
                    }
            }
//        }
    }

#Preview {
    @State var previewSelectedCard: Int?
    @State var previewSelectedModel: SampleModel?
    Deck(selectedCard: $previewSelectedCard, selectedModel: $previewSelectedModel)
    .modelContainer(SampleModel.preview)

}
