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
    
    
    
    
    func scheduleDailyForVerse(hour: Int, minute: Int,content:String,address:String) {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = address
        content.subtitle = "\(content)"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-\(hour)-\(minute)", content: content, trigger: trigger)

        // 동일 ID로 다시 예약하면 갱신 느낌으로 동작
        center.add(request, withCompletionHandler: nil)
    }
    
    
    
}







struct ScheduledAlarm: Identifiable {
    let id: String
    let title: String
    let hour: Int?
    let minute: Int?
    let repeats: Bool
}

extension NotificationManager {
    // 현재 예약된(대기중) 알림들을 시간 정보로 변환해서 넘겨줍니다.
    func getPending(completion: @escaping ([ScheduledAlarm]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let alarms: [ScheduledAlarm] = requests.compactMap { req in
                if let trig = req.trigger as? UNCalendarNotificationTrigger {
                    let h = trig.dateComponents.hour
                    let m = trig.dateComponents.minute
                    return ScheduledAlarm(
                        id: req.identifier,
                        title: req.content.title,
                        hour: h,
                        minute: m,
                        repeats: trig.repeats
                    )
                } else {
                    // 시간 트리거가 아닌 경우는 목록에서 제외(필요하면 표시 가능)
                    return nil
                }
            }
            // 시간순 정렬
            let sorted = alarms.sorted {
                ( ($0.hour ?? 0), ($0.minute ?? 0) ) < ( ($1.hour ?? 0), ($1.minute ?? 0) )
            }
            DispatchQueue.main.async { completion(sorted) }
        }
    }

    // 식별자로 개별 취소
    func cancel(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
