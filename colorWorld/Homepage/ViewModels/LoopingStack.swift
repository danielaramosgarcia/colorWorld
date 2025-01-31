import SwiftUI

struct LoopingStack<Content: View>: View {
    var maxTranslationWidth: CGFloat?
    var visibleCardsCount: Int = 5
    @Binding var selectedCard: Int?
    @ViewBuilder var content: Content
    @State private var rotation: Int = 0

    var body: some View {
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count

            ZStack {

                ForEach(collection.prefix(visibleCardsCount)) { view in
                    let index = collection.index(view)
                    let zIndex = Double(count - index)

                    LoopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation,
                        selectedCard: $selectedCard // Pasamos el estado de selección
                    ) {
                        view
                    }
                    .zIndex(selectedCard == index ? 100 : zIndex) // Trae la carta seleccionada al frente
                }
            }
        }
    }
}

// Vista individual para cada carta
private struct LoopingStackCardView<Content: View>: View {
    var index: Int
    var count: Int
    var visibleCardsCount: Int
    var maxTranslationWidth: CGFloat?
    @Binding var rotation: Int
    @Binding var selectedCard: Int? // Estado para manejar la carta seleccionada
    @ViewBuilder var content: Content

    @State private var offset: CGFloat = .zero
    @State private var viewSize: CGSize = .zero

    var body: some View {
        let maxRotation: CGFloat = 20
        let maxSpacing: CGFloat = 50
        let baseRotation = -maxRotation / 2
        let cardRotation = baseRotation + (maxRotation / CGFloat(visibleCardsCount - 1)) * CGFloat(index)
        let horizontalOffset = -maxSpacing + (maxSpacing * 2 / CGFloat(visibleCardsCount - 1)) * CGFloat(index)

        let rotation = max(min(-offset / viewSize.width, 1), 0) * -30

        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { viewSize = $0 })
            .rotationEffect(.degrees(selectedCard == index ? 0 : cardRotation)) // Se centra en caso de selección
            .offset(x: selectedCard == index ? 0 : horizontalOffset, y: selectedCard == index ? 0 : CGFloat(index) * -5)
            .offset(x: offset)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .rotation3DEffect(.init(degrees: selectedCard == index ? 0 : rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .scaleEffect(selectedCard == index ? 1.3 : 1) // Aumenta tamaño si está seleccionada
            .shadow(radius: selectedCard == index ? 10 : 5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let xOffset = -max(-value.translation.width, 0)
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1), 0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                    }
                    .onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        if (-offset + xVelocity) > (viewSize.width * 0.65) {
                            pushToNextCard()
                        }
                        withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                            offset = .zero
                        }
                    },
                isEnabled: selectedCard == nil && index == 0 && count > 1
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedCard = selectedCard == index ? nil : index // Alterna selección
                }
            }

    }

    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.05), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }
    }
}

extension SubviewsCollection {
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        guard !isEmpty else { return [] }
        let moveIndex = by % (count == 0 ? 1 : count)
        let rotatedElements = Array(self[moveIndex...]) + Array(self[0..<moveIndex])
        return rotatedElements
    }
}

extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    @State var previewSelectedCard: Int? // Estado de prueba para la selección

    Deck(selectedCard: $previewSelectedCard)
    .modelContainer(SampleModel.preview)
}
