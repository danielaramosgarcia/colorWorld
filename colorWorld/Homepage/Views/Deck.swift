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
    @Binding var selectedCard: Int? // Recibe el estado desde HomepageView

    var body: some View {
//        NavigationStack {
            VStack {
                LoopingStack(maxTranslationWidth: 200, selectedCard: $selectedCard) {
                        ForEach(samples) { card in
                            ColorCard(card: card)
                        }
                    }
            }
//        }
    }
}

#Preview {
    @State var previewSelectedCard: Int? // Estado de prueba para la selección

    Deck(selectedCard: $previewSelectedCard)
    .modelContainer(SampleModel.preview)

}
