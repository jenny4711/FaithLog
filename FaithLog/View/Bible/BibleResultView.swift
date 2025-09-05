//
//  BibleResultView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI
import SwiftData

struct BibleResultView: View {
    @Environment(DataService.self) var api
    @Environment(\.modelContext) private var context
    @Query private var favVerses:[FavVerse]
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
                    VStack(alignment: .leading, spacing: 16) {

                        
                        
                        Text("요약 내용")
                            .font(Font.semi20)
                            .padding(.leading,16)
                            .padding(.top,16)
                        

                            Text(api.bibleResp)
                                .font(Font.reg18)
                               
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .padding()
                              
                        
                    }//:요약
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.customText)
                    .foregroundColor(Color.customBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                   
                    .padding(.horizontal, 16)
                    
                    
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(api.bible) { verse in
                     
                               
                            VStack(alignment:.leading){
                                HStack{
                                                                    Text("\(verse.chapter)장 \(verse.verse)절")
                                                                        .font(Font.reg12)
                                                                        .foregroundColor(
                                                                            api.selectedBible.contains{$0.id == verse.id} ?
                                                                            Color.customBackground
                                                                            : Color.customOneText
                                                                        )
                                    Spacer()
                                                                    
                                                                    Button(action:{
                                                                        // api.like 대신 직접 favVerses 상태를 확인하고 토글
                                                                        let isAlreadyFavorited = favVerses.contains { favVerse in
                                                                            favVerse.verse == verse.verse &&
                                                                            favVerse.chapter == verse.chapter &&
                                                                            favVerse.title == verse.title
                                                                        }
                                                                        
                                                                        if isAlreadyFavorited {
                                                                            // 이미 좋아요된 상태라면 삭제
                                                                            do {
                                                                                let versesToDelete = favVerses.filter { favVerse in
                                                                                    favVerse.verse == verse.verse &&
                                                                                    favVerse.chapter == verse.chapter &&
                                                                                    favVerse.title == verse.title
                                                                                }
                                                                                
                                                                                for existingVerse in versesToDelete {
                                                                                    context.delete(existingVerse)
                                                                                }
                                                                                try context.save()
                                                                                print("unlike: \(verse.verse) - SwiftData에서 삭제됨")
                                                                            } catch {
                                                                                print("삭제 실패: \(error)")
                                                                            }
                                                                        } else {
                                                                            // 좋아요되지 않은 상태라면 추가
                                                                            let favVerse = FavVerse()
                                                                            favVerse.title = verse.title
                                                                            favVerse.lang = verse.lang
                                                                            favVerse.chapter = verse.chapter
                                                                            favVerse.verse = verse.verse
                                                                            favVerse.content = verse.content
                                                                            context.insert(favVerse)
                                                                            
                                                                            do {
                                                                                try context.save()
                                                                                print("liked: \(verse.verse) - SwiftData에 저장됨")
                                                                            } catch {
                                                                                print("저장 실패: \(error)")
                                                                            }
                                                                        }
                                                                        
                                                                        print(verse.verse)
                                                                    }){
                                                                        Image(systemName:
                                                                            // favVerses에서 해당 구절이 있는지 확인
                                                                            favVerses.contains { favVerse in
                                                                                favVerse.verse == verse.verse &&
                                                                                favVerse.chapter == verse.chapter &&
                                                                                favVerse.title == verse.title
                                                                            } ? "heart.fill" : "heart"
                                                                        )
                                                                        .foregroundColor(
                                                                            favVerses.contains { favVerse in
                                                                                favVerse.verse == verse.verse &&
                                                                                favVerse.chapter == verse.chapter &&
                                                                                favVerse.title == verse.title
                                                                            } ? .red : .red
                                                                        )
                                                                    }
                                }//:HSTACK
                                

                                                                .padding(.horizontal,20)
                                                                .padding(.top,10)
                                Button(action: {
                                    api.toggleBibleVerse(verse.verse)
                                    
                                    
                                }) {
                                    VStack(alignment: .leading, spacing: 5) {
                                                                           
                                        
                                        Text(verse.content)
                                        
                                            .font(Font.black18)
                                    }
                                    .padding()
//                                    .background(
//                                        api.selectedBible.contains { $0.id == verse.id }
//                                        ? Color.customText    // 선택됨 → 빨간색
//                                        : Color.customBackground      // 선택 안됨 → 기본색
//                                        
//                                        
//                                    )
                                    .foregroundColor(
                                        api.selectedBible.contains{$0.id == verse.id} ?
                                        Color.customBackground
                                        : Color.customOneText
                                    )
                                    .cornerRadius(8)
                                }//:LABEL
                            }//:VSTACK
                            
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(api.selectedBible.contains { $0.id == verse.id }
                                          ? Color.customText
                                          : Color.white)
                            )
                            .padding(10)
                          
                            
                           
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
