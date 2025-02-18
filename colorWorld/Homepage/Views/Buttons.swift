//
//  Buttons.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 17/02/25.
//

import SwiftUI
import PhotosUI

struct Buttons: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedCard: Int?
    @Binding var selectedData: Data
    @Binding var path: [Data]
    @Binding var selectedModel: SampleModel?
    @State private var imagePicker = ImagePicker()
    @State var viewModel: UpdateEditFormViewModel = UpdateEditFormViewModel()

    var body: some View {
        if selectedCard == nil {
            HStack {
                NavigationLink(destination: CameraView()) {
                    HStack {
                        Text("Add photo")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors:
                            [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                            )
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                }
                NavigationLink(destination: SelectedImage(image: selectedData)) {
                    HStack {
                        Text("Upload photo")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors:
                                    [ .green, .blue, .red]), startPoint: .leading, endPoint: .trailing)
                            )
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                    .padding(.leading, 15)
                    .overlay {
                        PhotosPicker(selection: $imagePicker.imageSelection) {
                            Color.clear
                        }
                    }
                    .onChange(of: imagePicker.imageSelection) { newSelection in
                        Task {
                            if let newSelection {
                                do {
                                    try await imagePicker.loadTransferable(from: newSelection)
                                    selectedData = viewModel.image.jpegData(compressionQuality: 0.8)!
                                        path.append(selectedData)
                                } catch {
                                    print("Error loading image: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                imagePicker.setup(viewModel)
            }
            .padding(.bottom, 100)
        } else {
            HStack {
                    HStack {
                        Text("Edit")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors:
                        [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                            )
                        Image(systemName: "pencil.tip.crop.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)

                HStack {
                    Text("Delete")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors:
                                    [ .green, .blue, .red]), startPoint: .leading, endPoint: .trailing)
                        )
                    Image(systemName: "trash.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                .padding(.leading, 15)
                .onTapGesture {
                    modelContext.delete(selectedModel!)
                    try? modelContext.save()
                    selectedCard = nil
                }

            }
            .padding(.bottom, 100)

        }

    }
}

#Preview {
    @State var selectedCard: Int?
    @State var selectedData: Data = Data()
    @State var path: [Data] = []
    @State var selectedModel: SampleModel?
    Buttons(selectedCard: $selectedCard, selectedData: $selectedData, path: $path, selectedModel: $selectedModel)
}
