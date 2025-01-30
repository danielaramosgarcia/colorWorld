//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI
import _SwiftData_SwiftUI

struct HomepageView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()
                    .background()
                VStack {
                    HStack {
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
                            .padding(.top, 20)

                        Spacer()
                        Button(action: {print("hola")}) {
                            Image(systemName: "info.circle")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }                            .padding(.horizontal, 60)
                    Spacer()
                        Deck()
                    Spacer()
                    NavigationLink(destination: CameraView()) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Add Photo")
                                    .font(.title)
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors:
                                            [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                                    )
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                        }
                    Spacer()

                }
            }
        }
    }
    }

#Preview {
    HomepageView()
        .modelContainer(SampleModel.preview)
}
