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
    var body: some View {
        NavigationStack {
            VStack {
                    LoopingStack(maxTranslationWidth: 200) {
                        ForEach(samples) { card in
                            ColorCard(card: card)

                        }
                    }
            }

        }
    }
}

#Preview {
    Deck()
    .modelContainer(SampleModel.preview)

}
