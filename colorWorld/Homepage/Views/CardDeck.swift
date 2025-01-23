//
//  cardDeck.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/01/25.
//

import SwiftUI

struct CardDeck: View {
    let deck: CardDeckModel
    var body: some View {
        ZStack {
            ForEach(0..<min(deck.cards.count, 6), id: \.self) { index in
                let totalCards = min(deck.cards.count, 6)
                let maxAngle: Double = 40
                let angleStep = maxAngle / Double(totalCards - 1)
                let baseAngle = -maxAngle / 2
                let angle = baseAngle + angleStep * Double(index)
                let radius: Double = 150
                let xOffset = radius * sin(angle * .pi / 180) * 3
                ColorCard(card: deck.cards[index])
                    .rotationEffect(.degrees(angle))
                    .offset(x: xOffset )
            }
        }
        .frame(width: 400, height: 300)
    }
}

 #Preview {
     CardDeck(deck: CardDeckModel.demoDeck)
 }
