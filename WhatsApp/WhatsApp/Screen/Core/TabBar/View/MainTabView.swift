import SwiftUI

struct MainTabView: View {
    
    //  MARK: - Property
    private let currentUser: User
    
    //  MARK: - Init
    init(_ currentUser: User) {
        self.currentUser = currentUser
        makeTabBarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    //  MARK: - body
    var body: some View {
        TabView {
            UpdatesTabView()
                .tabItem {
                    Image(systemName: Tabs.updates.icon)
                    Text(Tabs.updates.title)
                }
            CallsTabView()
                .tabItem {
                    Image(systemName: Tabs.calls.icon)
                    Text(Tabs.calls.title)
                }
            CommunityTabView()
                .tabItem {
                    Image(systemName: Tabs.communities.icon)
                    Text(Tabs.communities.title)
                }
            ChannelTabView()
                .tabItem {
                    Image(systemName: Tabs.chats.icon)
                    Text(Tabs.chats.title)
                }
            SettingsTabView()
                .tabItem {
                    Image(systemName: Tabs.settings.icon)
                    Text(Tabs.settings.title)
                }
        }
    }
    
    //  MARK: - Private
    private func makeTabBarOpaque() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

//  MARK: - MainTabView+Extension
extension MainTabView {
    private enum Tabs: String {
        case updates, calls, communities, chats, settings
        
        fileprivate var title: String {
            return rawValue.capitalized
        }
        
        fileprivate var icon: String {
            switch self {
            case .updates: return "circle.dashed.inset.filled"
            case .calls: return "phone"
            case .communities: return "person.3"
            case .chats: return "message"
            case .settings: return "gear"
            }
        }
    }
    
    private func placeholderItemView(_ title: String) -> some View {
        ScrollView {
            ForEach(0 ..< 51, id: \.self) { _ in
                VStack {
                    Text(title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.green.opacity(0.5))
                }
            }
        }
    }
}


#Preview {
    MainTabView(.placeholderUser)
}
