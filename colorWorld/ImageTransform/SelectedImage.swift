//
//  SelectedImage.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 31/01/25.
//

import SwiftUI
import CoreML
import Vision

struct SelectedImage: View {
    var imageData: Data
    @State private var nameInput: String = ""
    @State private var styledImage: UIImage?
    @State private var showNameError: Bool = false
    @State private var isLoading: Bool = false
    @Binding var path: [Data]
    @State private var navigateToPaint: Bool = false
    
    
    var body: some View {
        let originalUIImage = UIImage(data: imageData)

        ZStack {
            Gradiant()
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 5) {
                    if showNameError {
                        Text("The name is necessary for any art piece")
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    TextField("Name you art", text: $nameInput)
                        .textInputAutocapitalization(.sentences)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .padding(12)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showNameError ? Color.red : Color.white, lineWidth: 3)
                        )
                        .frame(width: 400)
                        .font(.system(size: 25))
                        .bold()
                }
                .padding(.bottom, -30)

                // Si se está aplicando la transformación, muestra un loading
                if isLoading {
                    ProgressView("Applying style, give me a sec...")
                        .padding()
                }

                // Se muestra la imagen transformada si existe, de lo contrario la original
                if let displayImage = styledImage ?? originalUIImage {
                    Image(uiImage: displayImage)
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

                // Botón para transformar o deshacer la transformación
                HStack {
                    Image(systemName: styledImage == nil ? "paintbrush.fill" : "arrow.uturn.backward")
                        .font(.title)
                        .foregroundColor(.black)
                    Text(styledImage == nil ? "Transfor" : "Undo")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .blue, .green]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 4)
                .padding(.top, -30)
                .onTapGesture {
                    if styledImage != nil {
                        // Permite volver a la imagen original
                        styledImage = nil
                    } else if let original = originalUIImage {
                        applyStyleTransfer(to: original)
                    }
                }
            }

            // NavigationLink oculto para pasar a Paint
            NavigationLink(
                destination: Paint(
                    imageData: (styledImage != nil
                                ? styledImage!.jpegData(compressionQuality: 1.0)!
                                : imageData),
                    name: nameInput,
                    path: $path
                ),
                isActive: $navigateToPaint
            ) {
                EmptyView()
            }
            .hidden()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Validación del nombre
                    if nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        withAnimation { showNameError = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation { showNameError = false }
                        }
                        return
                    }

                    // Si se está transformando, no permitimos navegar
                    if isLoading { return }

                    navigateToPaint = true
                } label: {
                    Text("Let's paint")
                }
                // Se deshabilita el botón mientras esté cargando
                .disabled(isLoading)
            }
        }
    }

    /// Aplica la transferencia de estilo al inputImage de forma asíncrona.
    func applyStyleTransfer(to inputImage: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Indicar que se inicia la transformación
            DispatchQueue.main.async {
                isLoading = true
            }

            guard let model = try? good(configuration: MLModelConfiguration()) else {
                print("Error loading the style model")
                DispatchQueue.main.async { isLoading = false }
                return
            }
            let targetSize = CGSize(width: 512, height: 512)
            guard let resizedImage = inputImage.resized(to: targetSize),
                  let pixelBuffer = resizedImage.toCVPixelBuffer(width: Int(targetSize.width), height: Int(targetSize.height)) else {
                print("Error al convertir la imagen a pixel buffer")
                DispatchQueue.main.async { isLoading = false }
                return
            }
            guard let output = try? model.prediction(image: pixelBuffer) else {
                print("Error durante la predicción de estilo")
                DispatchQueue.main.async { isLoading = false }
                return
            }
            guard let outputUIImage = UIImage(pixelBuffer: output.stylizedImage) else {
                print("Error al convertir la salida del modelo a UIImage")
                DispatchQueue.main.async { isLoading = false }
                return
            }
            let originalSize = inputImage.size
            guard let finalImage = outputUIImage.resized(to: originalSize) else {
                print("Error al redimensionar la imagen de salida")
                DispatchQueue.main.async { isLoading = false }
                return
            }
            DispatchQueue.main.async {
                styledImage = finalImage
                isLoading = false
            }
        }
    }
}

extension UIImage {
    /// Resize the image to a specified size.
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    /// Convert a UIImage to a CVPixelBuffer with BGRA format.
    func toCVPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attrs: CFDictionary = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32BGRA,
                                         attrs,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        guard let pixelData = CVPixelBufferGetBaseAddress(buffer) else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        guard let cgImage = self.cgImage else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }

    /// Initialize a UIImage from a CVPixelBuffer.
    convenience init?(pixelBuffer: CVPixelBuffer) {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage,
                                                  from: CGRect(x: 0,
                                                               y: 0,
                                                               width: CVPixelBufferGetWidth(pixelBuffer),
                                                               height: CVPixelBufferGetHeight(pixelBuffer))) else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            return nil
        }
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        self.init(cgImage: cgImage)
    }
}

#Preview {
    let peoniesImage = UIImage(named: "balon")
    let peoniesData = peoniesImage!.jpegData(compressionQuality: 1.0)
    @State var path: [Data] = []
    SelectedImage(imageData: peoniesData!, path: $path)
}
