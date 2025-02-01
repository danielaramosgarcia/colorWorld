//
//  ImagePicker.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 30/01/25.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
class ImagePicker {

    var image: Image?
    var images: [Image] = []

    var viewModel: UpdateEditFormViewModel?

    func setup(_ viewModel: UpdateEditFormViewModel) {
        self.viewModel = viewModel
    }
    var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }

    @MainActor
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                viewModel?.data = data
                if let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
}
