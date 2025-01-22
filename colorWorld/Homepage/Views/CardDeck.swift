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
                let spread: Double = 30
                let angleStep = spread / Double(totalCards - 1)
                let baseAngle = -spread / 2
                let angle = baseAngle + angleStep * Double(index)
                let xOffset = Double(index - (totalCards / 2)) * 40
                let yOffset = Double(index) * 15
                ColorCard(card: deck.cards[index])
                    .rotationEffect(.degrees(angle))
                    .offset(x: xOffset, y: yOffset)
            }
        }
    }
}

 #Preview {
     CardDeck(deck: CardDeckModel.demoDeck)
 }
