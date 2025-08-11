//
//  Bible.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import Foundation
import SwiftData

struct Bible:Codable,Identifiable,Hashable{
    var id = UUID()   // ForEach가 고유값으로 사용
    let title: String
    let label:String
    let value:String
    let pg:Int
    let version:String
    let initial :String
    
    private enum CodingKeys: String, CodingKey {
        case title, label, value, pg, version, initial
        // id는 제외 - JSON에 없으므로
    }
}

// API 응답을 위한 구조체
struct BibleResponse: Decodable {
    let message: String
    let result: [BibleBK]   // ✅ 여기에 진짜 데이터 배열이 들어 있음
}

@Model
class BibleBK: Identifiable, Decodable {
    @Attribute(.unique) var id: String
    var title: String
    var lang: String
    var chapter: String
    var verse: String
    var content: String
    
    init(title: String, lang: String, chapter: String, verse: String, content: String) {
        self.id = UUID().uuidString
        self.title = title
        self.lang = lang
        self.chapter = chapter
        self.verse = verse
        self.content = content
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, lang, chapter, verse, content
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.title = try container.decode(String.self, forKey: .title)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.content = try container.decode(String.self, forKey: .content)
        
        // chapter와 verse는 숫자나 문자열로 올 수 있으므로 안전하게 처리
        if let chapterInt = try? container.decode(Int.self, forKey: .chapter) {
            self.chapter = String(chapterInt)
        } else {
            self.chapter = try container.decode(String.self, forKey: .chapter)
        }
        
        if let verseInt = try? container.decode(Int.self, forKey: .verse) {
            self.verse = String(verseInt)
        } else {
            self.verse = try container.decode(String.self, forKey: .verse)
        }
    }
}






//struct BibleBK: Codable, Identifiable, Hashable {
//    var id = UUID()
//    let title: String
//    let lang: String
//    let chapter: Int
//    let verse: Int
//    let content: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case title, lang, chapter, verse, content
//        // id는 제외 - JSON에 없으므로
//    }
//    
//    // Hashable 구현
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: BibleBK, rhs: BibleBK) -> Bool {
//        lhs.id == rhs.id
//    }
//}

// Sheet item으로 사용하기 위한 래퍼 구조체
//struct BibleResultData: Identifiable {
//    let id = UUID()
//    let data: [BibleBK]
//}
