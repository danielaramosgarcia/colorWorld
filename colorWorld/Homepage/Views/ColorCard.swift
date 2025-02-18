//
//  ColorCard.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 30/12/24.
//

import SwiftUI
import SwiftData

struct ColorCard: View {
    let card: SampleModel
    var width: CGFloat? = 300
    var height: CGFloat? = 400
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    var body: some View {
        ZStack {
            // Imagen de fondo con marco (padding) blanco
            Group {
                if let uiImage = card.img {
                    if uiImage.size.width > uiImage.size.height {
                        // Si la imagen es horizontal, se rota 90° para ajustarse mejor
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .rotationEffect(.degrees(90))
                            .padding() // Padding para simular el marco blanco
                    } else {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .padding()
                    }
                } else {
                    Image("noCards")
                        .resizable()
                        .scaledToFill()
                        .padding()
                }
            }
            .frame(width: width, height: height)
            .clipped()

            // Texto o cualquier contenido adicional sobre la imagen
            VStack {
                Text(card.name)
                    .padding(3)
                    .padding(.horizontal, 6)
                    .bold()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                    )
                    .foregroundStyle(Color(.gray))
                    .padding(.top, 25)
                Spacer()
            }
        }
        .frame(width: width, height: height)
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
    @State var previewSelectedCard: Int?
    @State var previewSelectedModel: SampleModel?
    ColorCard(card: SampleModel(id: UUID(), name: "Ejemplo"), selectedCard: $previewSelectedCard, selectedModel: $previewSelectedModel)
}
