import SwiftUI

private struct BubbleTailModifier: ViewModifier {
    
    var direction: MessageDirection
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: direction == .incoming ? .bottomLeading : .bottomTrailing) {
                BubbleTailView(direction: direction)
            }
    }
}

extension View {
    func applyTail(_ direction: MessageDirection) -> some View {
        self.modifier(BubbleTailModifier(direction: direction))
    }
}
