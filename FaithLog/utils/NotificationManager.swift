//
//  NotificationManager.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/27/25.
//



import Foundation
import UserNotifications

// MARK: - Models


public struct VerseItem {
    public let title: String   // 예: "잠언 12장"
    public let body: String    // 예: 구절 내용
}


public struct ScheduledAlarm: Identifiable {
    public let id: String
    public let title: String
    public let hour: Int?
    public let minute: Int?
    public let repeats: Bool
    let year: Int?
        let month: Int?
        let day: Int?
}


public enum ReminderStyle {
    case dailyOnce         // 매일 1회(반복)
    case threeTimes6h      // 하루 3회(시작시각, +6h, +12h) — "날마다 다른 구절"
}

// MARK: - Notification Manager

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    /// 앱 시작 시 1번만 호출하세요 (App init 등)
    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }

        // 배너 액션: 열기 / 6시간 뒤 다시 / 완료
        let open   = UNNotificationAction(identifier: "OPEN_APP",
                                          title: "열기",
                                          options: [.foreground])
        let snooze = UNNotificationAction(identifier: "SNOOZE_6H",
                                          title: "6시간 뒤 다시")
        let done   = UNNotificationAction(identifier: "MARK_DONE",
                                          title: "완료",
                                          options: [.destructive])

        let category = UNNotificationCategory(
            identifier: "VERSE_CATEGORY",
            actions: [open, snooze, done],
            intentIdentifiers: [],
            options: []
        )
        center.setNotificationCategories([category])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let c = response.notification.request.content
        switch response.actionIdentifier {
        case "SNOOZE_6H":
            scheduleOneOff(afterHours: 6,
                           title: c.title,
                           body: c.body,
                           category: c.categoryIdentifier)
        case "MARK_DONE":
            center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
        case "OPEN_APP":
            break
        default:
            break
        }
        completionHandler()
    }
}

// MARK: - Public API

extension NotificationManager {

 
    func scheduleReminder(style: ReminderStyle,
                          startHour: Int,
                          startMinute: Int,
                          items: [VerseItem] = []) {
        switch style {
        case .dailyOnce:
            scheduleDaily(hour: startHour, minute: startMinute)

        case .threeTimes6h:
       
            let days = min(21, items.count)
            guard days > 0 else { return }
            scheduleDaily3x6h_RotatingDays(startHour: startHour,
                                           startMinute: startMinute,
                                           days: days,
                                           dayItems: Array(items.prefix(days)))
        }
    }

  
    func scheduleDaily(hour: Int,
                       minute: Int,
                       title: String = "묵상 시간",
                       body: String  = "묵상 하실 시간입니다.") {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return }

        let note = UNMutableNotificationContent()
        note.title = title
        note.body  = body
        note.sound = .default

        var dc = DateComponents(); dc.hour = hour; dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)

        let id = String(format: "daily-%02d:%02d", hour, minute)
        let req = UNNotificationRequest(identifier: id, content: note, trigger: trigger)
        UNUserNotificationCenter.current().add(req)
    }


    func scheduleDaily3x6h_RotatingDays(startHour: Int,
                                        startMinute: Int,
                                        days: Int,
                                        dayItems: [VerseItem]) {
        guard (0...23).contains(startHour), (0...59).contains(startMinute) else { return }

        let maxDays = min(days, 21) // 21일 * 3회 = 63개 (64 제한 보호)
        let starts = dailyStartSlots(startHour: startHour,
                                     startMinute: startMinute,
                                     days: maxDays)
        let dayCount = min(starts.count, dayItems.count)

        let center = UNUserNotificationCenter.current()
        let prefix = "verse3x6-"
        let cal = Calendar.current
        let now = Date()

        removePending(withPrefix: prefix) { // 이전 같은 접두어 예약 정리
            for i in 0..<dayCount {
                let item = dayItems[i]
                let base = starts[i] // 해당 날짜의 첫 회차(시작시각)

                // 0h, +6h, +12h → 하루 3회(같은 구절)
                for (slotIdx, offsetH) in [0, 6, 12].enumerated() {
                    guard let fire = cal.date(byAdding: .hour, value: offsetH, to: base),
                          fire > now else { continue }

                    let comp = cal.dateComponents([.year, .month, .day, .hour, .minute], from: fire)

                    let note = UNMutableNotificationContent()
                    note.title = item.title
                    note.body  = item.body
                    note.sound = .default
                    note.categoryIdentifier = "VERSE_CATEGORY"

                    // 고유 ID: verse3x6-YYYYMMDD-HHmm-#1..3
                    let y = comp.year ?? 0, m = comp.month ?? 0, d = comp.day ?? 0
                    let hh = comp.hour ?? 0, mm = comp.minute ?? 0
                    let id = String(format: "\(prefix)%04d%02d%02d-%02d%02d-#%d",
                                    y, m, d, hh, mm, slotIdx + 1)

                    let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
                    let req = UNNotificationRequest(identifier: id, content: note, trigger: trigger)
                    center.add(req)
                }
            }
        }
    }

    // 목록/취소 유틸 (선택)
    func getPending(completion: @escaping ([ScheduledAlarm]) -> Void) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let alarms: [ScheduledAlarm] = requests.compactMap { req in
                    guard let trig = req.trigger as? UNCalendarNotificationTrigger else { return nil }
                    let dc = trig.dateComponents
                    return ScheduledAlarm(
                        id: req.identifier,
                        title: req.content.title,
                        hour: dc.hour,
                        minute: dc.minute,
                        repeats: trig.repeats,
                        year: dc.year,
                        month: dc.month,
                        day: dc.day
                    )
                }
                // "가까운 날짜" 기준 정렬 (반복은 날짜 없음 → 뒤로)
                let sorted = alarms.sorted { a, b in
                    let ka = (a.year ?? 9999, a.month ?? 99, a.day ?? 99, a.hour ?? 99, a.minute ?? 99)
                    let kb = (b.year ?? 9999, b.month ?? 99, b.day ?? 99, b.hour ?? 99, b.minute ?? 99)
                    return ka < kb
                }
                DispatchQueue.main.async { completion(sorted) }
            }
        }
    
    
    func cancel(id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    func cancelAllPending() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func clearDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

// MARK: - Private helpers

private extension NotificationManager {
    /// 스누즈용 1회성 알림
    func scheduleOneOff(afterHours hours: Int,
                        title: String,
                        body: String,
                        category: String? = nil) {
        let note = UNMutableNotificationContent()
        note.title = title
        note.body  = body
        note.sound = .default
        if let category { note.categoryIdentifier = category }

        let ti = max(60, hours * 3600) // 60초 미만 불가
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(ti),
                                                        repeats: false)
        let req = UNNotificationRequest(identifier: "snooze-\(UUID().uuidString)",
                                        content: note,
                                        trigger: trigger)
        UNUserNotificationCenter.current().add(req)
    }

    /// 동일 접두어 예약 전부 제거
    func removePending(withPrefix prefix: String, completion: (() -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { reqs in
            let ids = reqs.map(\.identifier).filter { $0.hasPrefix(prefix) }
            center.removePendingNotificationRequests(withIdentifiers: ids)
            completion?()
        }
    }

    /// 오늘(또는 내일)부터 days개의 "하루 기준 시각" 배열 생성
    func dailyStartSlots(startHour: Int, startMinute: Int, days: Int) -> [Date] {
        precondition((0...23).contains(startHour) && (0...59).contains(startMinute))
        let cal = Calendar.current
        let now = Date()

        var todayDC = cal.dateComponents([.year, .month, .day], from: now)
        todayDC.hour = startHour
        todayDC.minute = startMinute
        todayDC.second = 0
        let todayStart = cal.date(from: todayDC)!

        // 이미 지난 시각이면 내일부터 시작
        let firstStart = (todayStart <= now)
            ? cal.date(byAdding: .day, value: 1, to: todayStart)!
            : todayStart

        return (0..<days).compactMap { cal.date(byAdding: .day, value: $0, to: firstStart) }
    }
}













