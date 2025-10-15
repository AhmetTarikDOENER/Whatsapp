import SwiftUI

struct BubbleAudioView: View {
    
    let item: MessageItem
    @State private var sliderValue: Double = 0
    @State private var sliderRange: ClosedRange<Double> = 0...20
    
    var body: some View {
        VStack(alignment: item.horizontalAlignment, spacing: 4) {
            HStack {
                playButton()
                
                Slider(value: $sliderValue, in: sliderRange)
                    .tint(.gray)
                
                Text("03:00")
                    .foregroundStyle(.gray)
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)
            
            timestampView()
        }
        .shadow(
            color: Color(.systemGray5).opacity(0.1),
            radius: 5,
            x: 0,
            y: 20
        )
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .incoming ? 5 : 100)
        .padding(.trailing, item.direction == .incoming ? 100 : 5)
    }
    
    private func playButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "play.fill")
                .padding(12)
                .background(item.direction == .incoming ? .green : .white)
                .clipShape(Circle())
                .foregroundStyle(item.direction == .incoming ? .white : .black)
        }
    }
    
    private func timestampView() -> some View {
        HStack {
            Text("12:34")
                .font(.system(size: 12))

            if item.direction == .outgoing {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
            }
        }
        .foregroundStyle(.gray)
        .clipShape(Capsule())
        .padding(12)
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .receivedPlaceholder)
        BubbleAudioView(item: .sentPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(.gray.opacity(0.5))
    .onAppear {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
}
