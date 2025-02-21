//
//  ModalView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/02/25.
//

import SwiftUI

struct ModalView: View {
    @Binding var showInfoModal: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Acerca de ColorWorld")
                .font(.title)
                .fontWeight(.bold)
            Text("Esta app ofrece una experiencia única. Se recomienda usarla en iPad en posición vertical para una mejor experiencia.")
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                showInfoModal = false
            }) {
                Text("Cerrar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    @State var showInfoModal: Bool = true
    ModalView(showInfoModal: $showInfoModal)
}
