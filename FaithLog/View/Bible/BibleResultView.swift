//
//  BibleResultView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI

struct BibleResultView: View {
    @Environment(DataService.self) var api
    var body: some View {
        VStack {
            if api.bible.isEmpty {
                Text("성경 구절을 불러오는 중...")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(api.bible) { verse in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(verse.chapter)장 \(verse.verse)절")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Text(verse.content)
                                    .foregroundColor(Color.red)
                                    .font(.body)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            print("BibleResultView appeared with \(api.bible.count) verses")
            print("result`````: \(api.bible)---------end")
        }
    }
}

#Preview {
    let dataService = DataService()
    dataService.bible = [BibleBK(title: "이사야서", lang: "kor", chapter: "4", verse: "1", content: "테스트 내용")]
    return BibleResultView()
        .environment(dataService)
}
