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
                let totalCards = min(deck.cards.count, 6) // Número de cartas en el abanico
                let maxAngle: Double = 40 // Ángulo total del abanico (en grados)
                let angleStep = maxAngle / Double(totalCards - 1) // Espaciado angular
                let baseAngle = -maxAngle / 2 // Ángulo inicial (centro del abanico)
                // Calcular ángulo para cada carta
                let angle = baseAngle + angleStep * Double(index)
                // Calcular posición usando seno y coseno
                let radius: Double = 150 // Radio del abanico
                let xOffset = radius * sin(angle * .pi / 180) * 3 // Conversión a radianes
                ColorCard(card: deck.cards[index])
                    .rotationEffect(.degrees(angle)) // Rotación de la carta
                    .offset(x: xOffset ) // Posición ajustada
            }
        }
        .frame(width: 400, height: 300)
    }
}

 #Preview {
     CardDeck(deck: CardDeckModel.demoDeck)
 }
