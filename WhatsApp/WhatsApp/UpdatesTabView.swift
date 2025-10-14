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

struct UpdatesTabView: View {
    
    @State private var searchText = ""
    
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
            }
            .listStyle(.grouped)
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
}

extension UpdatesTabView {
    enum Constant {
        static let imageDimension: CGFloat = 55
    }
}

#Preview {
    UpdatesTabView()
}
