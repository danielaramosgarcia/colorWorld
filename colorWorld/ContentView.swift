//
//  ContentView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 18/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .fontWeight(.bold)
                .italic()
                .foregroundColor(.pink)
            HStack {
                Text("hola")
                Text("hola")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
