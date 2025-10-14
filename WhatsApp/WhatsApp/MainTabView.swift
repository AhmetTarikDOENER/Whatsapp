import SwiftUI

extension MainTabView {
    private enum Tabs: String {
        case updates, calls, communities, chats, settings
        
        var title: String {
            return rawValue.capitalized
        }
        
        var icon: String {
            switch self {
            case .updates: return "circle.dashed.inset.filled"
            case .calls: return "phone"
            case .communities: return "person.3"
            case .chats: return "message"
            case .settings: return "gear"
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Updates")
                .tabItem {
                    Image(systemName: Tabs.updates.icon)
                    Text(Tabs.updates.title)
                }
            Text("Calls")
                .tabItem {
                    Image(systemName: Tabs.calls.icon)
                    Text(Tabs.calls.title)
                }
            Text("Communities")
                .tabItem {
                    Image(systemName: Tabs.communities.icon)
                    Text(Tabs.communities.title)
                }
            Text("Chats")
                .tabItem {
                    Image(systemName: Tabs.chats.icon)
                    Text(Tabs.chats.title)
                }
            Text("Settings")
                .tabItem {
                    Image(systemName: Tabs.settings.icon)
                    Text(Tabs.settings.title)
                }
        }
    }
}

#Preview {
    MainTabView()
}
