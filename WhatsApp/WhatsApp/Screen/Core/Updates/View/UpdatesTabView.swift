import SwiftUI

private struct StatusSectionHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.dashed")
                .foregroundStyle(.blue)
                .imageScale(.large)
            
            VStack {
                Text("Use status to share photos, text and videos that disappear in 24 hours.") + Text("\n")
                + Text("Status privacy")
                    .foregroundStyle(.blue).bold()
            }
            .padding(.horizontal)
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.whatsAppWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct StatusSection: View {
    var body: some View {
        HStack {
            Circle()
                .frame(
                    width: UpdatesTabView.Constant.imageDimension,
                    height: UpdatesTabView.Constant.imageDimension
                )
            
            VStack(alignment: .leading) {
                Text("My Status")
                    .font(.callout).bold()
                
                Text("Add to my status")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
            
            Spacer()
            
            makeCameraButton()
            makePencilButton()
        }
    }
    
    private func makeCameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera.fill")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
    
    private func makePencilButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "pencil")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
}

private struct RecentsUpdatesItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(
                    width: UpdatesTabView.Constant.imageDimension,
                    height: UpdatesTabView.Constant.imageDimension
                )
            
            VStack(alignment: .leading) {
                Text("John Applause")
                    .font(.callout).bold()
                
                Text("1h ago")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
        }
    }
}

private struct SuggestedChannelItemView: View {
    var body: some View {
        VStack {
            Circle()
                .frame(width: 55, height: 55)
            
            Text("Galatasaray F.K.")
            
            Button {
                
            } label: {
                Text("Follow")
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
    }
}

private struct ChannelListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stay updated on topics that matter to you. Find channels to follow below")
                .foregroundStyle(.gray)
                .font(.caption)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< 6, id: \.self) { _ in
                        SuggestedChannelItemView()
                    }
                }
            }
            
            Button("Explore More") { }
                .tint(.blue)
                .bold()
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(.vertical)
        }
    }
}

struct UpdatesTabView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    
    //  MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                StatusSectionHeader()
                    .listRowBackground(Color.clear)
                
                StatusSection()
                
                Section {
                    RecentsUpdatesItemView()
                } header: {
                    Text("Recent Updates")
                }
                
                Section {
                    ChannelListView()
                } header: {
                    makeChannelSectionHeader()
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
}

//  MARK: - UpdatesTabView+Extension
extension UpdatesTabView {
    enum Constant {
        static let imageDimension: CGFloat = 55
    }
    
    private func makeChannelSectionHeader() -> some View {
        HStack {
            Text("Channels")
                .bold()
                .font(.title3)
                .textCase(nil)
                .foregroundStyle(.whatsAppBlack)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .padding(12)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    UpdatesTabView()
}
