//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI

struct HomepageView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()
                    .background()
                VStack {
                    Spacer()
                    Text("ColorWorld")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                    ColorCard()
                    Spacer()
                    NavigationLink(destination: CameraView()) {
                        HStack {
                            Image(systemName: "camera.fill") // Ícono de cámara
                                .font(.title)               // Tamaño del ícono
                                .foregroundColor(.black)    // Color del ícono
                            Text("Add Drawing")
                                .font(.title)               // Tamaño de la fuente
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                                )                           // Letras de colores con gradiente
                        }
                        .padding()
                        .background(Color.white)            // Fondo blanco
                        .cornerRadius(30)                   // Bordes redondeados
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4) // Efecto de sombra
                    }
                    .padding(.top, 20)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomepageView()
}
