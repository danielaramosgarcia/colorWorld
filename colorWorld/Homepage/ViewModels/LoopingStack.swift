import SwiftUI

struct LoopingStack<Content: View>: View {
    var maxTranslationWidth: CGFloat?
    var visibleCardsCount: Int = 5 // Controla cuántas cartas son visibles
    @ViewBuilder var content: Content
    @State private var rotation: Int = 0

    var body: some View {
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count

            ZStack {
                ForEach(collection.prefix(visibleCardsCount)) { view in // Solo renderiza hasta visibleCardsCount
                    let index = collection.index(view)
                    let zIndex = Double(count - index)

                    LoopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation
                    ) {
                        view
                    }
                    .zIndex(zIndex)
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
    @ViewBuilder var content: Content

    @State private var offset: CGFloat = .zero
    @State private var viewSize: CGSize = .zero

    var body: some View {
        let maxRotation: CGFloat = 20 // Ángulo máximo de abanico
        let maxSpacing: CGFloat = 50  // Separación máxima horizontal
        let baseRotation = -maxRotation / 2
        let cardRotation = baseRotation + (maxRotation / CGFloat(visibleCardsCount - 1)) * CGFloat(index)
        let horizontalOffset = -maxSpacing + (maxSpacing * 2 / CGFloat(visibleCardsCount - 1)) * CGFloat(index)

        let rotation = max(min(-offset / viewSize.width, 1), 0) * -30 // Mantiene el efecto 3D

        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { viewSize = $0 })
            .rotationEffect(.degrees(cardRotation)) // Rotación en abanico
            .offset(x: horizontalOffset, y: CGFloat(index) * -5) // Espaciado horizontal
            .offset(x: offset)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .rotation3DEffect(.init(degrees: rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
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
                isEnabled: index == 0 && count > 1
            )
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
