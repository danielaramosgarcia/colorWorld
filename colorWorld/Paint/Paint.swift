//
//  SwiftUIView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 15/02/25.
//

import SwiftUI
import PencilKit

struct Paint: View {
    @Environment(\.modelContext) private var modelContext
    var imageData: Data
    var name: String
    @Binding var path: [Data]
    @StateObject var model = DrawingViewModel()

    var body: some View {
        ZStack {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            CanvasView(canvas: $model.canvas, toolPicker: $model.toolPicker, rect: UIScreen.main.bounds.size)
        }
        .onAppear {
            model.imageData = imageData
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    model.saveImage()
                    let newSample = SampleModel(id: UUID(), name: name, data: model.imageData)
                    modelContext.insert(newSample)
                    path = []
                } label: {
                    Text("Save Art")
                }
            }
        }
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    var rect: CGSize

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput

        // Configuración del toolPicker
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Aquí podrías actualizar el canvas si es necesario
    }
}

#Preview {
    let peoniesImage = UIImage(named: "balon")
    let peoniesData = peoniesImage!.jpegData(compressionQuality: 1.0)
    @State var path: [Data] = []
    Paint(imageData: peoniesData!, name: "Nuevo", path: $path)
}
