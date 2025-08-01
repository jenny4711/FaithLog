//
//  Bible.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import Foundation

struct BibleResponse: Decodable {
    let message: String
    let result: [Bible]   // ✅ 여기에 진짜 데이터 배열이 들어 있음
}



struct Bible:Decodable, Identifiable{
    var id = UUID()   // ForEach가 고유값으로 사용
        let title: String
        let chapter: Int
        let verse: Int
        let content: String
}
