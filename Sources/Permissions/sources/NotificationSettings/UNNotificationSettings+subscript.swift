import Foundation
import Idioms
import UserNotifications

@available(iOS 10.0, *)
extension UNNotificationSettings {
    public func settings(for options: UNAuthorizationOptions) -> [(UNAuthorizationOptions, UNNotificationSetting)] {
        var result = [(UNAuthorizationOptions, UNNotificationSetting)]()
        if options.contains(.alert) {
            result.append((.alert, alertSetting))
        } else if options.contains(.badge) {
            result.append((.badge, badgeSetting))
        } else if options.contains(.carPlay) {
            result.append((.carPlay, carPlaySetting))
        } else if options.contains(.sound) {
            result.append((.sound, soundSetting))
        }
        if #available(iOS 12.0, *) {
            if options.contains(.criticalAlert) {
                result.append((.criticalAlert, criticalAlertSetting))
            }
        }
        if #available(iOS 13.0, *) {
            if options.contains(.announcement) {
                result.append((.announcement, announcementSetting))
            }
        }
        return result
    }
}
