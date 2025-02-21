//
//  IntroPage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 13/02/25.
//

import SwiftUI

struct IntroPage: View {

    @Binding var showIntro: Bool

    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text("ColorWorld")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .blue, .green, .yellow]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .blur(radius: 5)
                        .overlay(
                            Text("ColorWorld")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .padding(.top, 40)
                    Spacer()
                }
                .padding(.top, 20)

                Spacer()

                VStack {
                    TabView {
                        VStack(spacing: 16) {
                            Image(systemName: "ipad.landscape")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue)

                            Text("Mejor experiencia en iPad parado")
                                .font(.title2)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text("Bienvenido a ColorWorld")
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .tag(0)

                        // Slide 2
                        VStack {
                            Text("Descubre tus colores favoritos")
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .tag(1)
                        VStack {
                            Text("¡Empecemos!")
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()

                                Text("Ir a Inicio")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        showIntro = false
                                    }
                        }
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }
                .frame(width: 600, height: 700)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)

                Spacer()
            }
    }
}

#Preview {
    @State var showIntro: Bool = true
    IntroPage(showIntro: $showIntro)
}
