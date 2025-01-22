//
//  CardModel.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/01/25.
//

import Foundation
import SwiftUICore
import UIKit

struct CardDeckModel: Identifiable {
    var id: Int
    var name: String?
    var cards: [CardModel]
    var numberOfCards: Int
}

struct CardModel: Identifiable {
    var id: Int
    var name: String
    var img: String?
}

extension CardModel {
    public static var peonies = CardModel(id: 1, name: "Peonies", img: "peonies")
    public static var boobie = CardModel(id: 2, name: "On family vacation", img: "boobie")
    public static var cozy = CardModel(id: 3, name: "Relaxing time!", img: "cozy")

}

extension CardDeckModel {
    public static var demoDeck = CardDeckModel(
        id: 1, name: "Demo Deck",
        cards: [CardModel.boobie, CardModel.cozy, CardModel.peonies, CardModel.boobie, CardModel.cozy, CardModel.peonies],
        numberOfCards: 6
    )
}
