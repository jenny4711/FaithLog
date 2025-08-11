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
                Text("\(api.bible[0].title)")
                    .font(Font.heavy25)
                    .padding(.top,20)
                    
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(api.bible) { verse in
                            
                            Button(action: {
                                api.toggleBibleVerse(verse.verse)
                                
                                
                            }) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(verse.chapter)장 \(verse.verse)절")
                                        .font(Font.reg12)
                                       
                                    Text(verse.content)
                                      
                                        .font(Font.black18)
                                }
                                .padding()
                                .background(
                                    api.selectedBible.contains { $0.id == verse.id }
                                        ? Color.customText    // 선택됨 → 빨간색
                                        : Color.customBackground      // 선택 안됨 → 기본색
                                    

                                )
                                .foregroundColor(
                                    api.selectedBible.contains{$0.id == verse.id} ?
                                    Color.customBackground
                                    : Color.customText
                                )
                                .cornerRadius(8)
                            }
                            
                           
                        }
                    }
                    .padding(10)
                }
            }
        }
        .background(Color.colorBackground)
        .foregroundColor(Color.colorText)
    }
}

//#Preview {
//    let dataService = DataService()
//    dataService.bible = [BibleBK(title: "이사야서", lang: "kor", chapter: "4", verse: "1", content: "테스트 내용")]
//    BibleResultView()
//        .environment(dataService)
//}
