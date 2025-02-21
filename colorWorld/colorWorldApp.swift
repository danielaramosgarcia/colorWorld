//
//  colorWorldApp.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 18/12/24.
//

import SwiftUI
import SwiftData

@main
struct ColorWorldApp: App {
    var body: some Scene {
        WindowGroup {
            HomepageView()
        }
//        .modelContainer(for: SampleModel.self)
        // good
        .modelContainer(SampleModel.preview)

    }
}
