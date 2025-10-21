import SwiftUI

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommunity = "New Community"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var imageName: String {
        switch self {
        case .newGroup: return "person.2.fill"
        case .newContact: return "person.fill.badge.plus"
        case .newCommunity: return "person.3.fill"
        }
    }
}

struct ChatPartnerPickerView: View {
    
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChatPartnerPickerViewModel()
    var onCreate: (_ newChannel: Channel) -> Void
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationStack) {
            List {
                ForEach(ChatPartnerPickerOption.allCases) { item in
                    ChatPartnerHeaderSectionItemView(item: item) {
                        guard item == ChatPartnerPickerOption.newGroup else { return }
                        viewModel.navigationStack.append(.groupPartnerPicker)
                    }
                }
                
                Section {
                    ForEach(viewModel.users) { user in
                        ChatPartnerRowView(user: user)
                            .onTapGesture {
                                viewModel.createDirectChannel(user, completion: onCreate)
                            }
                    }
                } header: {
                    Text("Contacts on WhatsApp")
                        .textCase(nil)
                        .bold()
                }
                
                if viewModel.isPaginatable {
                    loadMoreUsersView()
                }
            }
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChannelCreationRoute.self, destination: { route in
                destinationView(for: route)
            })
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search name or number"
            )
            .toolbar {
                makeTrailingNavigationItem()
            }
            .onAppear {
                viewModel.deselectAllChatPartners()
            }
            .alert(isPresented: $viewModel.errorState.showError) {
                Alert(
                    title: Text(viewModel.errorState.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func loadMoreUsersView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUser()
            }
    }
}

//  MARK: - ChatPartnerPickerView+Extension
extension ChatPartnerPickerView {
    
    //  MARK: - ChatPartnerHeaderItemView
    private struct ChatPartnerHeaderSectionItemView: View {
        
        let item: ChatPartnerPickerOption
        let onTapHandler: () -> Void
        
        var body: some View {
            Button {
                onTapHandler()
            } label: {
                makeButton()
            }
        }
        
        //  MARK: - Private
        private func makeButton() -> some View {
            HStack {
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                Text(item.title)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func makeTrailingNavigationItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

extension ChatPartnerPickerView {
    @ViewBuilder
    private func destinationView(for route: ChannelCreationRoute) -> some View {
        switch route {
        case .groupPartnerPicker:
            GroupPartnerPickerView(viewModel: viewModel)
        case .setupGroupChat:
            NewGroupSetupView(viewModel: viewModel, onCreate: onCreate)
        }
    }
}

#Preview {
    ChatPartnerPickerView { channel in
        
    }
}
