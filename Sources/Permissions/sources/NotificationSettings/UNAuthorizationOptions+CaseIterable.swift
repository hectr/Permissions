import Foundation
import UserNotifications

@available(iOS 10.0, *)
extension UNAuthorizationOptions: CaseIterable {
    public typealias AllCases = [UNAuthorizationOptions]
    public static var allCases: [UNAuthorizationOptions] {
        if #available(iOS 13.0, *) {
            return [.announcement, .badge, .sound, .alert, .carPlay, .criticalAlert, .providesAppNotificationSettings, .provisional]
        } else if #available(iOS 12.0, *) {
            return [.badge, .sound, .alert, .carPlay, .criticalAlert, .providesAppNotificationSettings, .provisional]
        } else {
            return [.badge, .sound, .alert, .carPlay]
        }
    }
}
