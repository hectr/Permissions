import Foundation
import UserNotifications

extension UNAuthorizationOptions: CaseIterable {
    public typealias AllCases = [UNAuthorizationOptions]
    public static var allCases: [UNAuthorizationOptions] {
        #if os(iOS) || targetEnvironment(macCatalyst)
        return [.announcement, .badge, .sound, .alert, .carPlay, .criticalAlert, .providesAppNotificationSettings, .provisional]
        #else
        return [.badge, .sound, .alert, .carPlay, .criticalAlert, .providesAppNotificationSettings, .provisional]
        #endif
    }
}
