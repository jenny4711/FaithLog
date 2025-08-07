//
//  Bible.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import Foundation

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

struct BibleBK: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let lang: String
    let chapter: String
    let verse: String
    let content: String
    // _id와 __v 필드는 JSON에 있지만 모델에서는 무시
    
    private enum CodingKeys: String, CodingKey {
        case title, lang, chapter, verse, content
        // id, _id, __v는 제외
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
