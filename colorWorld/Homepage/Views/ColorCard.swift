//
//  ColorCard.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 30/12/24.
//

import SwiftUI

struct ColorCard: View {
    let titulo: String
    var body: some View {
        ZStack {
            Image("cozy")
                .resizable()
                .padding()
            VStack {
                Text(titulo)
                    .padding(3)
                    .padding(.horizontal, 6)
                    .bold()
                    .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white) // Fondo blanco
                                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 3)
                                )
                    .foregroundStyle(Color(.blue))
                    .padding(.top, 20)
                Spacer()
            }
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
        .padding(1)
    }
}

#Preview {
    ColorCard(titulo: "Cozy!")
}
