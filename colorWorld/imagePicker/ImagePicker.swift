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

    var vm: UpdateEditFormViewModel?

    func setup(_ vm: UpdateEditFormViewModel) {
        self.vm = vm
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
                vm?.data = data
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
