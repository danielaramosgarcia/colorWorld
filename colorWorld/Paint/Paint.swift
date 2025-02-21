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
    @State var viewModel: UpdateEditFormViewModel
    @Binding var path: [Data]
    @StateObject var model = DrawingViewModel()
    @State private var navigateToHome: Bool = false
    var isUpdate: Bool = false
    var selectedModel: SampleModel?

    var body: some View {
        ZStack {
            Gradiant()
                .ignoresSafeArea()
            if let uiImage = UIImage(data: viewModel.data!) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            CanvasView(canvas: $model.canvas, toolPicker: $model.toolPicker, rect: UIScreen.main.bounds.size)
        }
        .onAppear {
            model.imageData = viewModel.data!
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    model.saveImage()

                    if isUpdate {
                        modelContext.delete(selectedModel!)
                        try? modelContext.save()
                        let newSample = SampleModel(id: UUID(), name: viewModel.name, data: model.imageData)
                        modelContext.insert(newSample)
                        print("LLEGO A UPDATE")
                        navigateToHome = true
                    } else {
                        let newSample = SampleModel(id: UUID(), name: viewModel.name, data: model.imageData)
                        modelContext.insert(newSample)
                        print("LLEGO A NEW SAMPLE")
                        navigateToHome = true
                        path = []
                    }
                } label: {
                    Text("Save Art")
                }
                NavigationLink(
                    destination: HomepageView(),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
                .hidden()

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
    @State var viewModel: UpdateEditFormViewModel = UpdateEditFormViewModel()
    @State var isUpdate: Bool = false
    Paint(viewModel: viewModel, path: $path, isUpdate: isUpdate)
}
