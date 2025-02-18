//
//  IntroPage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 13/02/25.
//

import SwiftUI

struct IntroPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()

                VStack {
                    // Título en la parte superior de la pantalla
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
                        Spacer()
                    }
                    .padding(.top, 20)

                    Spacer()

                    // Rectángulo blanco con los slides
                    VStack {
                        TabView {
                            // Slide 1
                            VStack {
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

                            // Slide 3 con botón para ir a HomepageView()
                            VStack {
                                Text("¡Empecemos!")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding()

                                NavigationLink(destination: HomepageView()) {
                                    Text("Ir a Inicio")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                            .tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    }
                    .frame(width: 600, height: 500)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    IntroPage()
}
