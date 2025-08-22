//
//  BibleResultView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI

struct BibleResultView: View {
    @Environment(DataService.self) var api
//    @StateObject private  var askAI = AskAI()
    @State private var showAi:Bool = false
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
                    
                    // AI 해설 섹션
                    VStack(alignment: .leading, spacing: 12) {

                        
                        
                        if  showAi {

                            Text(api.bibleResp)
                                .font(Font.reg18)
                                .foregroundColor(Color.customBackground)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.customText)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }else {
                            Button(action: {
                                showAi.toggle()
                            }) {
                                Text(api.bibleResp == "" ? "AI 해설을 불러오는 중...":"AI 요약 보기")
                                    .font(Font.reg12)
                                    .foregroundColor(Color.gray.opacity(0.6))
                                    .italic()
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                           
                        }
                    }//:BTN
                    

                   
                    .padding(.horizontal, 16)
                    
                    
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
                .scrollIndicators(.hidden)
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
