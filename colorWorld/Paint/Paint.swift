//
//  SwiftUIView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 15/02/25.
//

import SwiftUI

struct Paint: View {

    var body: some View {
        ZStack {
            Gradiant()
                .ignoresSafeArea()

        }
    }
}

#Preview {
    Paint()
}
