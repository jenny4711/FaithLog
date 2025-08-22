//
//  MarkdownStyledText.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//
import SwiftUI

struct MarkdownStyledText: View {
    let markdown: String

    var body: some View {
        Text(makeAttr(markdown))
                   .padding()
                   .lineSpacing(6)
    }
    private func makeAttr(_ s: String) -> AttributedString {
        var result = AttributedString()
        let lines = s.replacingOccurrences(of: "\r\n", with: "\n").components(separatedBy: "\n")

        for (i, rawLine) in lines.enumerated() {
            let trimmed = rawLine.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("##") {
                // "## " 제거 후 제목만 표시
                let title = trimmed.drop(while: { $0 == "#" || $0 == " " })
                var a = AttributedString(String(title))
                a.font = .system(size: 20, weight: .bold)
                result.append(a)
            }
            else if trimmed.hasPrefix("**") {
                // "**제목**" 탐색
                let afterOpen = trimmed.dropFirst(2)                // 첫 "**" 뒤
                if let close = afterOpen.range(of: "**") {
                    let title = afterOpen[..<close.lowerBound]
                    let rest  = afterOpen[close.upperBound...]      // 닫는 "**" 뒤 내용

                    var a = AttributedString(String(title))
                    a.font = .system(size: 22, weight: .bold)
                    result.append(a)

                    // 제목 뒤에 내용이 붙어 있으면 강제 줄바꿈 후 본문으로
                    let restStr = String(rest).trimmingCharacters(in: .whitespaces)
                    if !restStr.isEmpty {
                        result.append(AttributedString("\n"))
                        var b = AttributedString(restStr)
                        b.font = .system(size: 18)
                        result.append(b)
                    }
                } else {
                    var a = AttributedString(rawLine)
                    a.font = .system(size: 16)
                    result.append(a)
                }
            }
            else {
                var a = AttributedString(rawLine)
                a.font = .system(size: 16)
                result.append(a)
            }

            // 원본 줄바꿈 유지
            if i < lines.count - 1 { result.append(AttributedString("\n")) }
        }
        return result
    }

}

/// 마크다운 전처리: 헤더/소제목 뒤에 줄바꿈 보장
private func normalizeMarkdown(_ md: String) -> String {
    var s = md

    // (A) ATX 헤더(`## ...`) 뒤에 빈 줄 보장
    // 멀티라인 모드: 각 줄 끝에 \n\n 없으면 추가
    let headerPattern = #"(?m)^(#{1,6}\s.+?)(?:\s*)$"#
    s = s.replacingOccurrences(of: headerPattern, with: "$1\n", options: .regularExpression)

    // (B) 줄 맨 앞의 볼드 소제목 뒤에 줄바꿈 (이미 줄바꿈 있으면 건드리지 않음)
    // 예: "**소제목**설명" -> "**소제목**\n설명"
    // 리스트 항목(`- `, `* `, `1. `)에서도 동작
    let boldLeadPattern =
    #"(?m)^(?:\s*(?:[-*]|\d+[.)])\s*)?(\*\*[^*\n]+\*\*)(?!\s*\n)"#
    s = s.replacingOccurrences(of: boldLeadPattern, with: "$1\n", options: .regularExpression)

    return s
}
















//import SwiftUI
//import Foundation
//
//struct MarkdownStyledText: View {
//    let markdown: String
//
//    var body: some View {
//        Text(styled(markdown))
//            .padding()
//    }
//
//    private func styled(_ md: String) -> AttributedString {
//        // 마크다운 파싱
//        guard var attr = try? AttributedString(
//            markdown: md,
//            options: .init(allowsExtendedAttributes: true, interpretedSyntax: .full)
//        ) else {
//            return AttributedString(md)
//        }
//
//        // 기본 본문 스타일
//        var base = AttributeContainer()
//        base.font = .system(size: 16, weight: .regular)
//        base.foregroundColor = .primary
//        attr.mergeAttributes(base, mergePolicy: .keepCurrent)
//
//        // 긴 타입 이름 줄이기
//        typealias Fnd = AttributeScopes.FoundationAttributes
//
//        // 구간별 스타일 적용
//        for run in attr.runs {
//            let range = run.range
//
//            // 1) 블록 의도: 제목/리스트/인용 등
//            if let pres = run[Fnd.PresentationIntentAttribute.self] {
//                for comp in pres.components {
//                    switch comp.kind {
//                    case .header(let level):
//                        switch level {
//                        case 1:
//                            attr[range].font = .system(size: 26, weight: .bold)
//                            attr[range].foregroundColor = .blue
//                        case 2:
//                            attr[range].font = .system(size: 22, weight: .bold)
//                            attr[range].foregroundColor = .blue
//                        case 3:
//                            attr[range].font = .system(size: 19, weight: .semibold)
//                            attr[range].foregroundColor = .blue
//                        default:
//                            attr[range].font = .system(size: 18, weight: .semibold)
//                            attr[range].foregroundColor = .blue
//                        }
//                    default:
//                        break
//                    }
//                }
//            }
//
//            // 2) 인라인 의도: **굵게**, *기울임*, `코드`
//            if let inline = run.inlinePresentationIntent {
//                if inline.contains(.stronglyEmphasized) {
//                    attr[range].font = .system(size: 16, weight: .semibold)
//                }
//                if inline.contains(.emphasized) {
//                    attr[range].font = .system(size: 16).italic()
//                }
//                if inline.contains(.code) {
//                    attr[range].font = .system(.body, design: .monospaced)
//                    // 필요하면 배경색 등 추가
//                }
//            }
//        }
//
//        return attr
//    }
//}
