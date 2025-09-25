//
//  Strings.swift
//  FaithLog
//
//  Created by Ji y LEE on 9/22/25.
//

import Foundation
import UIKit   // iOS라면 없어도 동작하지만, NSAttributedString(HTML) 사용 시 보통 함께 둡니다.

// HTML → 일반 텍스트 변환(하나로 통일)
extension String {
    var htmlPlain: String {
        guard let data = self.data(using: .utf8) else { return self }
        let opts: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attr = try? NSAttributedString(data: data, options: opts, documentAttributes: nil) {
            return attr.string
        }
        return self
    }
}

/// NLT HTML을 "1 …", "2 …" 형태의 절별 배열로 변환
/// - Parameters:
///   - html: NLT API에서 받은 HTML 원문
///   - stripFootnoteMarkers: [a], *1:16 같은 각주 마커를 제거할지 여부
///   - allowSkippedNumbers: 절 번호가 건너뛰는 경우도 허용(권장: true)
func nltHTMLToVerseArray(
    _ html: String,
    stripFootnoteMarkers: Bool = false,
    allowSkippedNumbers: Bool = true
) -> [String] {

    // 1) HTML → plain
    var text = html.htmlPlain

    // 2) 선택: 각주 마커 간단 제거(필요 시 on)
    if stripFootnoteMarkers {
        // [a], [b] 같은 마커
        text = text.replacingOccurrences(of: #"\[[a-z]\]"#, with: "", options: .regularExpression)
        // *1:16 형태의 마커
        text = text.replacingOccurrences(of: #"\*\d+:[0-9a-z\-]+"#, with: "", options: .regularExpression)
    }

    // 3) 공백 정리
    text = text
        .replacingOccurrences(of: "\r\n", with: "\n")
        .replacingOccurrences(of: "\u{00A0}", with: " ") // NBSP → space
        .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)

    // 4) 숫자(절 번호) 경계 탐지
    //    - 앞 문자가 영숫자/별/콜론/하이픈이면 제외(주석/연속 숫자 등 오탐 방지)
    //    - 숫자 뒤에는 공백이 옴
    let pattern = #"(?<![\w\*:\-])([1-9]\d{0,2})(?=\s)"#
    guard let re = try? NSRegularExpression(pattern: pattern) else { return [] }

    let ns = text as NSString
    let matches = re.matches(in: text, options: [], range: NSRange(location: 0, length: ns.length))
    if matches.isEmpty { return [] }

    // 5) 절 시작 인덱스 수집
    var starts: [(num: Int, loc: Int)] = []
    var last = 0
    for m in matches {
        let numStr = ns.substring(with: m.range(at: 1))
        guard let n = Int(numStr) else { continue }

        if allowSkippedNumbers {
            // 오름차순이면 채택(1,2,4,5… 등 건너뛰기 허용)
            if n > last {
                starts.append((n, m.range.location))
                last = n
            }
        } else {
            // 정확히 1씩 증가만 허용
            if (last == 0 && n >= 1) || n == last + 1 {
                starts.append((n, m.range.location))
                last = n
            }
        }
    }
    if starts.isEmpty { return [] }

    // 6) 절별 문자열 추출 & "번호 본문" 정규화
    var out: [String] = []
    for i in 0..<starts.count {
        let start = starts[i].loc
        let end = (i + 1 < starts.count) ? starts[i + 1].loc : ns.length
        var chunk = ns.substring(with: NSRange(location: start, length: end - start))
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let space = chunk.firstIndex(of: " ") {
            let num = String(chunk[..<space]).trimmingCharacters(in: .whitespaces)
            let body = String(chunk[chunk.index(after: space)...]).trimmingCharacters(in: .whitespaces)
            chunk = "\(num) \(body)"
        }
        out.append(chunk)
    }
    return out
}





/// HTML 태그 제거 + 공백 정리
private func stripTagsAndCollapse(_ html: String) -> String {
    var s = html
    // 흔한 각주/주석 블록 제거 (있을 때만)
    s = s.replacingOccurrences(of: #"(?is)<aside[^>]*>.*?</aside>"#, with: " ", options: .regularExpression)
    s = s.replacingOccurrences(of: #"(?is)<span[^>]*class="[^"]*footnote[^"]*"[^>]*>.*?</span>"#, with: " ", options: .regularExpression)

    // 모든 태그 제거
    s = s.replacingOccurrences(of: #"(?is)<[^>]+>"#, with: " ", options: .regularExpression)

    // 흔한 각주 마커 정리: * 2:1 … (마침표까지)
    s = s.replacingOccurrences(of: #"\*\s*\d+:\d+[^.]*\."#, with: " ", options: .regularExpression)

    // 대괄호 안 주석(단위설명 등) 제거(원치 않으면 이 줄은 주석 처리)
    s = s.replacingOccurrences(of: #"\[[^\]]+\]"#, with: " ", options: .regularExpression)

    // 공백 정리
    s = s.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
         .trimmingCharacters(in: .whitespacesAndNewlines)
    return s
}

/// NLT HTML → ["1 …","2 …"] (가능하면 HTML의 <sup>절번호</sup> 기준 사용)
func nltHTMLToVerseArray(_ html: String) -> [String] {
    var h = html

    // 1) footnote/aside 등 흔한 블록 제거(있을 때만)
    h = h.replacingOccurrences(of: #"(?is)<aside[^>]*>.*?</aside>"#, with: " ", options: .regularExpression)
    h = h.replacingOccurrences(of: #"(?is)<div[^>]*class="[^"]*footnote[^"]*"[^>]*>.*?</div>"#, with: " ", options: .regularExpression)
    h = h.replacingOccurrences(of: #"(?is)<span[^>]*class="[^"]*footnote[^"]*"[^>]*>.*?</span>"#, with: " ", options: .regularExpression)

    // 2) <sup> n </sup> 패턴으로 절 경계 식별
    let supRE = try! NSRegularExpression(pattern: #"(?is)<sup[^>]*>\s*([1-9]\d{0,2})\s*</sup>"#)
    let ns = h as NSString
    let matches = supRE.matches(in: h, range: NSRange(location: 0, length: ns.length))

    if matches.count > 0 {
        var out: [String] = []
        for i in 0..<matches.count {
            let m = matches[i]
            let num = ns.substring(with: m.range(at: 1))

            let start = m.range.location + m.range.length
            let end = (i + 1 < matches.count) ? matches[i + 1].range.location : ns.length
            guard end > start else { continue }

            let chunkHTML = ns.substring(with: NSRange(location: start, length: end - start))
            var body = stripTagsAndCollapse(chunkHTML)
            if !body.isEmpty {
                out.append("\(num) \(body)")
            }
        }
        return out
    }

    // 3) 폴백: 평문화 후 숫자 경계로 자르기 (절번호 뒤에 공백이 없어도 잡도록)
    var plain = stripTagsAndCollapse(html)
    // 절번호 탐지: 앞은 단어 문자가 아니고(lookbehind), 숫자 뒤엔 "다음 문자가 숫자가 아님"
    let re = try! NSRegularExpression(pattern: #"(?<![\w*:\-])([1-9]\d{0,2})(?=[^\d])"#)
    let ns2 = plain as NSString
    let ms = re.matches(in: plain, range: NSRange(location: 0, length: ns2.length))
    if ms.isEmpty { return [] }

    var starts: [(Int, Int)] = []
    var last = 0
    for m in ms {
        let n = Int(ns2.substring(with: m.range(at: 1))) ?? 0
        if n > last { // 건너뛰기 허용(1,2,4,5…)
            starts.append((n, m.range.location))
            last = n
        }
    }

    var out: [String] = []
    for i in 0..<starts.count {
        let (_, loc) = starts[i]
        let end = (i + 1 < starts.count) ? starts[i + 1].1 : ns2.length
        var chunk = ns2.substring(with: NSRange(location: loc, length: end - loc)).trimmingCharacters(in: .whitespacesAndNewlines)

        if let space = chunk.firstIndex(where: { $0.isWhitespace }) {
            let num = String(chunk[..<space])
            let body = String(chunk[chunk.index(after: space)...]).trimmingCharacters(in: .whitespaces)
            chunk = "\(num) \(body)"
        }
        out.append(chunk)
    }
    return out
}
