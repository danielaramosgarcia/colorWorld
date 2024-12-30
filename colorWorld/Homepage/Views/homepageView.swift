//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI

struct HomepageView: View {
    var body: some View {
        ZStack {
            Gradiant()
                .ignoresSafeArea()
                .background()
            Text("ColorWorld")
                .bold()
                .font(.largeTitle)
        }
    }
}

#Preview {
    HomepageView()
}
