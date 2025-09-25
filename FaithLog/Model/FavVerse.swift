//
//  FavVerse.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/28/25.
//

import Foundation
import SwiftData
@Model
class FavVerse{
    @Attribute(.unique) var id: String
    var title: String
    var lang: String
    var chapter: String
    var verse: String
    var content: String
    var date:Date?
    
    init(title: String, lang: String, chapter: String, verse: String, content: String,date:Date) {
        self.id = UUID().uuidString
        self.title = title
        self.lang = lang
        self.chapter = chapter
        self.verse = verse
        self.content = content
        self.date = date
    }





     init() {
        self.id = UUID().uuidString
        self.title = ""
        self.lang = ""
        self.chapter = ""
        self.verse = ""
        self.content = ""
         self.date = .now
    }
    
    
    // 하루당 1개만 사용(다음 날로 넘어갈수록 다음 구절), days 개 생성
    func makeDailyVerseItems(from favs: [FavVerse], days: Int) -> [VerseItem] {
        guard !favs.isEmpty, days > 0 else { return [] }
        let key = "verseDayRotationIndex" // 일 단위 회전 인덱스
        var idx = UserDefaults.standard.integer(forKey: key) // 기본 0

        var out: [VerseItem] = []
        out.reserveCapacity(days)
        for _ in 0..<days {
            let v = favs[idx % favs.count]
            out.append(VerseItem(title: "\(v.title) \(v.chapter)장", body: v.content))
            idx += 1
        }
        UserDefaults.standard.set(idx % max(1, favs.count), forKey: key)
        return out
    }

    
}

