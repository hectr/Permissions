import Foundation
import UserNotifications

extension UNNotificationSettings {
    public func settings(for options: UNAuthorizationOptions) -> [(UNAuthorizationOptions, UNNotificationSetting)] {
        var result = [(UNAuthorizationOptions, UNNotificationSetting)]()
#if os(iOS) || targetEnvironment(macCatalyst) || os(macOS)
        if options.contains(.alert) {
            result.append((.alert, alertSetting))
        }
        if options.contains(.badge) {
            result.append((.badge, badgeSetting))
        }
        if options.contains(.sound) {
            result.append((.sound, soundSetting))
        }
        if options.contains(.criticalAlert) {
            result.append((.criticalAlert, criticalAlertSetting))
        }
#if !os(macOS)
        if options.contains(.carPlay) {
            result.append((.carPlay, carPlaySetting))
        }
        if options.contains(.announcement) {
            result.append((.announcement, announcementSetting))
        }
#endif
#endif
        return result
    }
}

