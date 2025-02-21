//
//  DrawingViewModel.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 18/02/25.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false // no usare esto

    @Published var imageData: Data = Data(count: 0)
    // Canvas for drawing
    @Published var canvas = PKCanvasView()

    @Published var toolPicker = PKToolPicker()

    @Published var rect: CGRect = .zero

    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }

    func saveImage() {
        // Verifica que el canvas tenga un tamaño válido y que la imagen de fondo sea correcta.
        guard canvas.bounds.size != .zero, let bgImage = UIImage(data: imageData) else {
            print("Error: canvas size invalid or iamge size invalid")
            return
        }

        // Usar el tamaño real del canvas para el renderer
        let rendererSize = canvas.bounds.size
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        let finalImage = renderer.image { _ in
            // Dibujar la imagen de fondo en todo el canvas
            bgImage.draw(in: CGRect(origin: .zero, size: rendererSize))

            // Extraer y dibujar el dibujo realizado en el canvas
            let drawingImage = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: CGRect(origin: .zero, size: rendererSize))
        }

        // Actualizar la propiedad para que el modelo guarde la imagen compuesta
        if let finalImageData = finalImage.jpegData(compressionQuality: 1.0) {
            imageData = finalImageData
        }

        // Guardar la imagen en la galería (asegúrate de tener el permiso NSPhotoLibraryAddUsageDescription en Info.plist)
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        print("Saved succesfully!")
    }

}
