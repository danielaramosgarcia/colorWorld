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
    @State private var showCamera = false
    @State private var cameraError: CameraPermission.CameraError?
    @State private var navigateToPaint: Bool = false

    var body: some View {
        if selectedCard == nil {
            HStack {
                NavigationLink(
                    destination: SelectedImage(imageData: selectedData, path: $path)) {
                    HStack {
                        Text("Take photo")
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
                    .onTapGesture {
                        if let error = CameraPermission.checkPermissions() {
                            cameraError = error
                        } else {
                            showCamera.toggle()
                        }
                    }
                    .alert(isPresented: .constant(cameraError != nil), error: cameraError) { _ in
                            Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "Try again later")
                        }
                    .sheet(isPresented: $showCamera) {
                        UIKitCamera(selectedImage: $viewModel.cameraImage)
                            .ignoresSafeArea()
                    }
                    .onChange(of: viewModel.cameraImage) {
                        if let image = viewModel.cameraImage {
                            viewModel.data = image.jpegData(compressionQuality: 0.8)
                            selectedData = viewModel.data!
                            path.append(selectedData)
                        }
                    }
                }
                NavigationLink(destination: SelectedImage(imageData: selectedData, path: $path)) {
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
                    .onTapGesture {
                        viewModel.id = selectedModel!.id
                        viewModel.name = selectedModel!.name
                        viewModel.data = selectedModel?.data
                        selectedCard = nil
                        navigateToPaint = true
                    }
                NavigationLink(
                    destination: Paint(
                        viewModel: viewModel,
                        path: $path,
                        isUpdate: true,
                        selectedModel: selectedModel
                    ),
                    isActive: $navigateToPaint
                ) {
                    EmptyView()
                }
                .hidden()

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
