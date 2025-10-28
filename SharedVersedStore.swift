//
//  SharedVersedStore.swift
//  FaithLog
//
//  Created by Ji y LEE on 10/24/25.
//

import Foundation

enum SharedVerseStore {
    // ⚠️ 실제 App Group ID로 변경
    private static let appGroupID = "group.com.jenny4711.faithlog"

    static let suite: UserDefaults = {
        guard let ud = UserDefaults(suiteName: appGroupID) else {
            // 위젯/앱에서 App Group 미설정 시 디버그 도움
            assertionFailure("App Group not configured: \(appGroupID)")
            return .standard
        }
        return ud
    }()

    struct Keys {
        static let nextVerseText = "nextVerseText"
        static let nextFireDate  = "nextFireDate"   // timeIntervalSince1970 (Double)
        static let lastShownText = "lastShownText"
        static let scheduleJSON  = "verseScheduleJSON"
    }

    static func saveNext(verse: String, fireDate: Date) {
        suite.set(verse, forKey: Keys.nextVerseText)
        suite.set(fireDate.timeIntervalSince1970, forKey: Keys.nextFireDate)
        suite.synchronize()
    }

    static func setLastShown(_ verse: String) {
        suite.set(verse, forKey: Keys.lastShownText)
    }

    static func getNext() -> (String?, Date?) {
        let v = suite.string(forKey: Keys.nextVerseText)
        let t = suite.double(forKey: Keys.nextFireDate)
        return (v, t > 0 ? Date(timeIntervalSince1970: t) : nil)
    }

    static func getLastShown() -> String? {
        suite.string(forKey: Keys.lastShownText)
    }
}
