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
                    CardDeck()
                    Spacer()
                    NavigationLink(destination: CameraView()) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.black)
                            Text("Add Drawing")
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
