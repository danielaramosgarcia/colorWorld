//
//  ColorCard.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 30/12/24.
//

import SwiftUI

struct ColorCard: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
        }
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(
            color: Color.black.opacity(0.2),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

#Preview {
    ColorCard()
        .padding()
}
