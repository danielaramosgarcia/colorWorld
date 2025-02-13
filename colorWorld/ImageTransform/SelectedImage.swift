//
//  SelectedImage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 31/01/25.
//

import SwiftUI

struct SelectedImage: View {
    var image: SampleModel? // Received Image
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var nameInput: String = ""

    var body: some View {
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

                if image != nil && image?.img != nil {
                    Image(uiImage: (image?.img == nil ? Constants.placeholder : image?.img)!)
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
                } else {
                    Text("No image selected")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
//            .textFieldStyle(.roundedBorder)

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    modelContext.insert(image!)
                        dismiss()
                } label: {
                    Text( "Add")
                }
//                .disabled(view.isDisabled)
            }
        }

    }
}

#Preview {

    @Previewable @State var viewModel: UpdateEditFormViewModel = UpdateEditFormViewModel()
    let peoniesImage = UIImage(named: "peonies")
    let peoniesData = peoniesImage?.jpegData(compressionQuality: 1.0)
    SelectedImage(image: SampleModel(id: UUID(), name: "hi", data: peoniesData))
}
