//
//  bibleApi.swift
//  FaithLog
//
//  Created by Ji y LEE on 9/22/25.
//

import Foundation
import SwiftData
// NLT API는 HTML을 반환하므로 우선 원문을 받아옵니다.
struct NLTResponse: Decodable { let data: String? } // 응답 형식이 단순 문자열일 수도 있어서 안전하게
// be5bb19a-fef1-4659-892c-9da75ca252d7
// f5113ff3-9808-48a0-b1ff-1682b5dc03c0
func fetchNLTChapter(book: String, chapter: Int) async throws -> String {
    // 예: John 3
    let ref = "\(book).\(chapter)"
    // 공식 테스트 키: key=TEST (개발/테스트 용도, 일일 호출 제한 있음)
    var comp = URLComponents(string: "https://api.nlt.to/api/passages")!
    comp.queryItems = [
        URLQueryItem(name: "ref", value: ref),
        URLQueryItem(name: "key", value:"be5bb19a-fef1-4659-892c-9da75ca252d7")
    ]
    let (data, _) = try await URLSession.shared.data(from: comp.url!)
    // 대부분 HTML 문자열이 오므로 우선 그대로 반환
    return String(data: data, encoding: .utf8) ?? ""
}
