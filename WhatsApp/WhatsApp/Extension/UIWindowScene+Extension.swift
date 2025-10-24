import UIKit

extension UIWindowScene {
    
    static var currentWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .first { $0 is UIWindowScene } as? UIWindowScene
    }
    
    var screenHeight: CGFloat {
        return UIWindowScene.currentWindowScene?.screen.bounds.height ?? 0
    }
    
    var screenWidth: CGFloat {
        return UIWindowScene.currentWindowScene?.screen.bounds.width ?? 0
    }
}
