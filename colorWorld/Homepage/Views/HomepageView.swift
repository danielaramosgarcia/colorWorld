//
//  homepageView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI
import _SwiftData_SwiftUI
import PhotosUI

struct HomepageView: View {
    @State private var selectedCard: Int? // Guarda el índice de la carta seleccionada
    @State private var selectedCardModel: SampleModel? // Guarda el índice de la carta seleccionada
    @State var viewModel: UpdateEditFormViewModel
    @State private var imagePicker = ImagePicker()

    var body: some View {
        NavigationStack {
            ZStack {
                Gradiant()
                    .ignoresSafeArea()
                    .background()
                VStack {
                    HStack {
                        Text("ColorWorld")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.red, .blue, .green, .yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .blur(radius: 5)
                            .overlay(
                                Text("ColorWorld")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .padding(.top, 20)

                        Spacer()
                        if selectedCard == nil {
                            Button(action: {
                                print("hola")
                            }
                            ) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }
                    }                            .padding(.horizontal, 60)
                    Spacer()
//                    if selectedCard == nil {
                        Deck(selectedCard: $selectedCard)
//                    if selectedCard != nil {
//                        ColorCard(card: SampleModel(id: 1, name: "hola"))
//                            .scaleEffect(1.3)
//                    }
                    Spacer()
                    if selectedCard == nil {

                        HStack {
                            NavigationLink(destination: CameraView()) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .foregroundColor(.black)
                                    Text("Add photo")
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
                            }

                                HStack {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundColor(.black)
                                    Text("Select photo")
                                        .font(.title)
                                        .foregroundStyle(
                                            LinearGradient(gradient: Gradient(colors:
                                        [ .green, .blue, .red]), startPoint: .leading, endPoint: .trailing)
                                        )
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
                                    .onTapGesture {
                                        imagePicker.setup(viewModel)
                                    }
                                }

                        }
                    }
                    Spacer()

                }
            }
        }
    }
    }

#Preview {
    HomepageView(viewModel: UpdateEditFormViewModel())
        .modelContainer(SampleModel.preview)
}
