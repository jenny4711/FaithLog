//
//  StringExt.swift
//  FaithLog
//
//  Created by Ji y LEE on 9/3/25.
//
import Foundation
extension String {
    /// 특수문자가 포함되어 있으면 true, 아니면 false
    var containsSpecialCharacter: Bool {
        let pattern = "[^a-zA-Z0-9가-힣\\s]"
        // 알파벳, 숫자, 한글, 공백 제외 → 나머지는 특수문자로 간주
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
