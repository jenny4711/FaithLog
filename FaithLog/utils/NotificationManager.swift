//
//  NotificationManager.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/27/25.
//

import SwiftUI
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _,_ in }
    }

    // 앱이 포그라운드일 때도 배너/사운드/배지 보이기
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    // 매일 특정 시간에 반복 알림
    func scheduleDaily(hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "묵상 시간"
        content.subtitle = "묵상 하실 시간입니다."
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-\(hour)-\(minute)", content: content, trigger: trigger)

        // 동일 ID로 다시 예약하면 갱신 느낌으로 동작
        center.add(request, withCompletionHandler: nil)
    }

    // 1회성(오늘 시간 지나면 내일로 보정)
    func scheduleOneOff(hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return }

        let now = Date()
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: now)
        comps.hour = hour
        comps.minute = minute

        var fireDate = Calendar.current.date(from: comps)!
        if fireDate <= now {
            fireDate = Calendar.current.date(byAdding: .day, value: 1, to: fireDate)!
        }

        let match = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: match, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "묵상 시간"
        content.subtitle = "묵상 하실 시간입니다."
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
