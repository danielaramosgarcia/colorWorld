//
//  gradiant.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 23/12/24.
//

import SwiftUI

struct Gradiant: View {
    @State var appear = false

    var body: some View {
        MeshGradient(
            width: 3, height: 3, points: [
                [0.0, 0.0], [appear ? 0.5 : 0.3, 0.0], [1.0, 0.0],
                [0.0, appear ? 0.5 : 0.3], [0.5, 0.5], [1.0, appear ? 0.5 : 0.1],
                [0, 1.0], [appear ?  0.5 : 0.8, 1.0], [1.0, 1.0]
            ],
            colors: [
                appear ? .cyan : .mint,
                appear ? Color("moradito") : .cyan,
                appear ? Color("rosa") : Color("rosaClaro"),
                appear ? .blue : Color("rosaClaro"),
                appear ? .cyan : Color("moradito"),
                appear ? Color("rosaClaro") : Color("celeste"),
                appear ? Color("celeste") : .cyan,
                appear ? .mint : Color("celeste"),
                appear ? Color("moradito") : .mint
            ])
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) { appear.toggle() }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { appear.toggle() }
            }
        }
    }

#Preview {
    Gradiant()
}
