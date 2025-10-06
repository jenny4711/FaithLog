import SwiftUI
import Foundation

struct MarkdownStyledText: View {
    let markdown: String

    var body: some View {
        Text(makeAttr(markdown))
            .padding()
            .lineSpacing(13)
    }

    private func makeAttr(_ s: String) -> AttributedString {
        var result = AttributedString()
        
        // 원문을 줄 단위로
        let lines = s.replacingOccurrences(of: "\r\n", with: "\n").components(separatedBy: "\n")

        for (i, rawLine) in lines.enumerated() {
            let trimmed = rawLine.trimmingCharacters(in: .whitespaces)

            if let numbered = splitNumberedLine(trimmed) {
                var titleLine = AttributedString(numbered.numberToken + " " + numbered.title)
                titleLine.font = .system(size: 16, weight: .bold)
                
                result.append(titleLine)

                //  설명이 있으면 다음 줄에 일반체로
                if let desc = numbered.desc, !desc.isEmpty {
                    result.append(AttributedString("\n"))
                    var bodyLine = AttributedString(desc)
                    bodyLine.font = .system(size: 16)
                    result.append(bodyLine)
                }

            } else {
                // 일반 줄
                var a = AttributedString(rawLine)
                a.font = .system(size: 16)
                result.append(a)
            }

            // 원본 줄바꿈 유지
            if i < lines.count - 1 { result.append(AttributedString("\n")) }
        }
        return result
    }

    // MARK: - Helpers

    /// "1. ...", "2) ...", "3 ..." 같은 번호 줄을 파싱하고
    /// 한 줄에 **제목** 설명 / 제목 - 설명 / 제목: 설명 형태면 제목과 설명을 분리해준다.
    private func splitNumberedLine(_ line: String) -> (numberToken: String, title: String, desc: String?)? {
        // 번호 토큰 추출: "1.", "2)", "3" + 공백
        guard let m = line.range(of: #"^\s*(\d+([.)])?)\s+(.*)$"#,
                                 options: .regularExpression) else { return nil }

        let afterNumber = String(line[m]).replacingOccurrences(
            of: #"^\s*(\d+([.)])?)\s+"#,
            with: "",
            options: .regularExpression
        )
        // number token 재추출
        let numberToken = String(line[m]).replacingOccurrences(
            of: #"^\s*(\d+([.)])?)\s+.*$"#,
            with: "$1",
            options: .regularExpression
        )

        // 1) **제목** 설명  형태 처리 (출력에서는 ** 제거)
        if let boldRange = afterNumber.range(of: #"\*\*(.+?)\*\*"#, options: .regularExpression) {
            let titleRaw = String(afterNumber[boldRange])
            let title = titleRaw.replacingOccurrences(of: #"\*\*"#, with: "", options: .regularExpression)
            let desc = afterNumber[boldRange.upperBound...].trimmingCharacters(in: .whitespaces)
            return (numberToken, title, desc.isEmpty ? nil : desc)
        }

        // 2) "제목 - 설명" 또는 "제목: 설명" 형태
        if let sepRange = afterNumber.range(of: #"(\s-\s|:\s)"#, options: .regularExpression) {
            let title = afterNumber[..<sepRange.lowerBound].trimmingCharacters(in: .whitespaces)
            let desc = afterNumber[sepRange.upperBound...].trimmingCharacters(in: .whitespaces)
            return (numberToken, title, desc.isEmpty ? nil : desc)
        }

        // 3) 분리 기준이 없다면 전부 제목으로 간주 (설명 없음)
        return (numberToken, afterNumber.trimmingCharacters(in: .whitespaces), nil)
    }
}
