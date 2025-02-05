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
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?
    var body: some View {
        ZStack {
            Image(uiImage: (card.img == nil ? Constants.placeholder : card.img)!)
                .resizable()
                .scaledToFit()
                .padding()
            VStack {
                Text(card.name)
                    .padding(3)
                    .padding(.horizontal, 6)
                    .bold()
                    .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 3)
                                )
                    .foregroundStyle(Color(.blue))
                    .padding(.top, 25)
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
    @State var previewSelectedCard: Int?
    @State var previewSelectedModel: SampleModel?
    ColorCard(card: SampleModel(id: UUID(), name: "hola"), selectedCard: $previewSelectedCard, selectedModel: $previewSelectedModel)
}
