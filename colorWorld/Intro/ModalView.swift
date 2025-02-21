//
//  ModalView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/02/25.
//

import SwiftUI

struct ModalView: View {
    @Binding var showInfoModal: Bool

    let facts = [
        "CreateML and CoreML with a style transfer model to create drawings.",
        "PencilKit for coloring and drawing on the canvas.",
        "The Vision and PhotosUI frameworks to select photos from your gallery.",
        "AVFoundation and UIKit for handling camera interactions."
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Some cool facts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("You are using...")
                .font(.title2)
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(facts, id: \.self) { fact in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color("rosa"))
                            .padding(.top, 4)
                        Text(fact)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.horizontal)
            Button(action: {
                showInfoModal = false
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color("celeste"))
                    .cornerRadius(10)
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    HomepageView()
        .modelContainer(SampleModel.preview)
}
