//
//  SelectedImage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 31/01/25.
//

import SwiftUI

struct SelectedImage: View {
    var image: Data
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var nameInput: String = ""

    var body: some View {
        let newUiImage = UIImage(data: image)

        ZStack {
            Gradiant()
                .ignoresSafeArea()
                .background()
            VStack {
                TextField("Give your art a name", text: $nameInput)
                    .textInputAutocapitalization(.sentences)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)

                    )
                    .frame(width: 400)
                    .padding(.bottom, -30)
                    .font(.system(size: 25))
                    .bold()

                if newUiImage != nil {
                    Image(uiImage: newUiImage!)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .scaledToFit()
                        .padding(80)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 10)
                                .padding(76)
                        )
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .font(.title)
                            .foregroundColor(.black)
                        Text("Transform")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors:
                        [.red, .blue, .green]), startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                    .padding(.top, -30)

                } else {
                    Text("No image selected")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let newSample: SampleModel = SampleModel(id: UUID(), name: nameInput, data: image)
                    modelContext.insert(newSample)
                        dismiss()
                } label: {
                    Text( "Let's paint")
                }
//                .disabled(view.isDisabled)
            }
        }

    }
}

#Preview {
    let peoniesImage = UIImage(named: "peonies")
    let peoniesData = peoniesImage!.jpegData(compressionQuality: 1.0)
    SelectedImage(image: peoniesData!)
}
