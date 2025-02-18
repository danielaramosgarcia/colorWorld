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
    var image: Data
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var nameInput: String = ""
    @State private var styledImage: UIImage? // Transformed image
    @State private var showNameError: Bool = false  // Controls error display

    var body: some View {
        // The original image from the data.
        let originalUIImage = UIImage(data: image)

        ZStack {
            Gradiant()
                .ignoresSafeArea()
                .background()
            VStack {
                VStack(spacing: 5) {
                    // Error message shown on top if name is missing.
                    if showNameError {
                        Text("The name is necessary, every art piece needs one")
                            .font(.headline) // Bigger font
                            .foregroundColor(.white)
                    }

                    TextField("Give your art a name", text: $nameInput)
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

                // Display the transformed image if available; otherwise, show the original.
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

                // Transform / Undo button
                HStack {
                    Image(systemName: styledImage == nil ? "paintbrush.fill" : "arrow.uturn.backward")
                        .font(.title)
                        .foregroundColor(.black)
                    Text(styledImage == nil ? "Transform" : "Undo")
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
                    // Toggle style transformation
                    if styledImage != nil {
                        styledImage = nil
                    } else if let original = originalUIImage {
                        applyStyleTransfer(to: original)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Validate that the name is not empty.
                    if nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        withAnimation {
                            showNameError = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showNameError = false
                            }
                        }
                        return
                    }

                    // Save the displayed image (transformed or original)
                    let imageToSave: Data
                    if let styled = styledImage, let styledData = styled.jpegData(compressionQuality: 1.0) {
                        imageToSave = styledData
                    } else {
                        imageToSave = image
                    }

                    let newSample = SampleModel(id: UUID(), name: nameInput, data: imageToSave)
                    modelContext.insert(newSample)
                    dismiss()
                } label: {
                    Text("Let's paint")
                }
            }
        }
    }

    /// Applies the style transfer model to the input image.
    func applyStyleTransfer(to inputImage: UIImage) {
        // Run on background to avoid blocking the UI.
        DispatchQueue.global(qos: .userInitiated).async {
            // Initialize the model.
            guard let model = try? good_two(configuration: MLModelConfiguration()) else {
                print("Error loading style transfer model")
                return
            }

            // The model expects images of 512x512.
            let targetSize = CGSize(width: 512, height: 512)
            // Resize the input image and convert it to a CVPixelBuffer in BGRA format.
            guard let resizedImage = inputImage.resized(to: targetSize),
                  let pixelBuffer = resizedImage.toCVPixelBuffer(width: Int(targetSize.width), height: Int(targetSize.height)) else {
                print("Error converting image to pixel buffer")
                return
            }

            // Execute the prediction.
            guard let output = try? model.prediction(image: pixelBuffer) else {
                print("Error during style transfer prediction")
                return
            }

            // Convert the output (CVPixelBuffer) to a UIImage.
            guard let outputUIImage = UIImage(pixelBuffer: output.stylizedImage) else {
                print("Error converting model output to UIImage")
                return
            }

            // Resize the output image to the original image size to avoid distortion.
            let originalSize = inputImage.size
            guard let finalImage = outputUIImage.resized(to: originalSize) else {
                print("Error resizing the output image to original size")
                return
            }

            // Update the UI on the main thread.
            DispatchQueue.main.async {
                self.styledImage = finalImage
            }
        }
    }
}

//
// MARK: - Extensions for converting UIImage to CVPixelBuffer and vice versa
//

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
    let peoniesImage = UIImage(named: "yo")
    let peoniesData = peoniesImage!.jpegData(compressionQuality: 1.0)
    SelectedImage(image: peoniesData!)
}
