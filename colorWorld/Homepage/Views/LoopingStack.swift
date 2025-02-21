//
//  LoppingStack.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 29/12/24.
//

import SwiftUI
import _SwiftData_SwiftUI

// Enum para identificar la dirección del swipe
enum SwipeDirection {
    case left, right
}

struct LoopingStack: View {
    // Consulta directa de modelos, sin pasar parámetros innecesarios.
    @Query(sort: \SampleModel.date, order: .reverse) var samples: [SampleModel]
    var maxTranslationWidth: CGFloat? = 200
    var visibleCardsCount: Int = 5

    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    // Estado para controlar la rotación (para animación)
    @State private var rotation: Int = 0

    var body: some View {
        let count = samples.count
        // Se obtiene el arreglo rotado; la función 'rotated(by:)' devuelve una copia sin alterar el arreglo original.
        let displaySamples = samples.rotated(by: rotation)

        ZStack {
            if count > 0 {
                ForEach(Array(displaySamples.prefix(visibleCardsCount).enumerated()), id: \.element.id) { index, sample in
                    let zIndex = Double(count - index)

                    LoopingStackCardView(
                        model: sample,
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation,
                        selectedCard: $selectedCard,
                        selectedModel: $selectedModel

                    ) {
                        ColorCard(card: sample, selectedCard: $selectedCard, selectedModel: $selectedModel)
                    }
                    .zIndex(selectedCard == index ? 100 : zIndex) // La carta seleccionada queda en frente
                    .opacity(selectedCard == nil || selectedCard == index ? 1 : 0)
                    .animation(.easeInOut(duration: 0.4), value: selectedCard)
                }
            } else {
                let noCardsImage = UIImage(named: "noCards")
                let noCardsData = noCardsImage!.jpegData(compressionQuality: 1.0)
                let sample = SampleModel(id: UUID(), name: "No cards yet", data: noCardsData)
                    ColorCard(card: sample, selectedCard: $selectedCard, selectedModel: $selectedModel)
            }
        }
    }
}

// Vista individual para cada carta del deck.
private struct LoopingStackCardView<Content: View>: View {
    var model: SampleModel

    var index: Int
    var count: Int
    var visibleCardsCount: Int
    var maxTranslationWidth: CGFloat?

    @Binding var rotation: Int
    @Binding var selectedCard: Int?
    @Binding var selectedModel: SampleModel?

    @ViewBuilder var content: Content

    @State private var offset: CGFloat = .zero
    @State private var viewSize: CGSize = .zero

    var body: some View {

        let maxRotation: CGFloat = 20
        let maxSpacing: CGFloat = 50
        let baseRotation = -maxRotation / 2
        let cardRotation = baseRotation + (maxRotation / CGFloat(visibleCardsCount - 1)) * CGFloat(index)
        let horizontalOffset = -maxSpacing + (maxSpacing * 2 / CGFloat(visibleCardsCount - 1)) * CGFloat(index)

        // Calcula el ángulo de rotación 3D de forma simétrica según la dirección del swipe.
        let rotationValue: CGFloat = {
            if offset < 0 {
                return max(min(-offset / viewSize.width, 1), 0) * -30
            } else {
                return min(offset / viewSize.width, 1) * 30
            }
        }()

        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { viewSize = $0 })
            .rotationEffect(.degrees(selectedCard == index ? 0 : cardRotation))
            .offset(
                x: selectedCard == index ? 0 : horizontalOffset,
                y: selectedCard == index ? 0 : CGFloat(index) * -5
            )
            .offset(x: offset)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .rotation3DEffect(
                .init(degrees: selectedCard == index ? 0 : rotationValue),
                axis: (0, 1, 0),
                anchor: .center,
                perspective: 0.5
            )
            .scaleEffect(selectedCard == index ? 1.6 : 1)
            .shadow(radius: selectedCard == index ? 10 : 5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Actualiza el offset según el arrastre.
                        offset = value.translation.width
                    }
                    .onEnded { value in
                        // Umbral para considerar el swipe.
                        let threshold = viewSize.width * 0.65
                        if offset < 0 {
                            let xVelocity = max(-value.velocity.width / 5, 0)
                            if (-offset + xVelocity) > threshold {
                                pushToNextCard(direction: .left)
                            }
                        } else if offset > 0 {
                            let xVelocity = max(value.velocity.width / 5, 0)
                            if (offset + xVelocity) > threshold {
                                pushToNextCard(direction: .right)
                            }
                        }
                        withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                            offset = .zero
                        }
                    },
                isEnabled: selectedCard == nil && index == 0 && count > 1
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    if selectedCard == index {
                        // Deselecciona la carta
                        selectedCard = nil
                        selectedModel = nil
                    } else {
                        // Selecciona la carta y asigna su modelo
                        selectedCard = index
                        selectedModel = model
                    }
                }
            }
    }

    /// Anima la carta fuera de la pantalla y actualiza la rotación para mover la carta al fondo.
    private func pushToNextCard(direction: SwipeDirection) {
        let targetOffset: CGFloat = direction == .left ? -viewSize.width : viewSize.width
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.05), completionCriteria: .logicallyComplete) {
            offset = targetOffset
        } completion: {
            // Independientemente de la dirección, se incrementa la rotación para mover la carta superior al fondo.
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }
    }
}

// Extensión para rotar arreglos sin modificar el arreglo original.
extension Array {
    func rotated(by shift: Int) -> [Element] {
        guard !isEmpty else { return self }
        // Se asegura que el shift quede en el rango [0, count)
        let modShift = ((shift % count) + count) % count
        return Array(self[modShift..<count] + self[0..<modShift])
    }
}

#Preview {
    @State var previewSelectedCard: Int?
    @State var previewSelectedModel: SampleModel?

    LoopingStack(selectedCard: $previewSelectedCard, selectedModel: $previewSelectedModel)
        .modelContainer(SampleModel.preview)
}
