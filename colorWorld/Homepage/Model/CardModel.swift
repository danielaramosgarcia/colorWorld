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
    var cardNumber: Int
}

struct CardModel: Identifiable {
    var id: Int
    var name: String
    var img: UIImage?
}
