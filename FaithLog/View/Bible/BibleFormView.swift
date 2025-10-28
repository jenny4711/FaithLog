//
//  BibleFormView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI
import Foundation

struct BibleFormView: View {
    @State var openResult: Bool = false
    @Environment(DataService.self) var api
    @Environment(\.dismiss) var dismiss
    @State var selectedBible: Bible?
    @State var aiResult:String = ""
    @State var chapter: Int = 1
    @State private var verses: [String] = []
//    @Binding var showBibleForm:Bool
    @State private var searchText: String = ""
   
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    
    var filteredBibles: [Bible] {
            let key: (Bible) -> String = { lang ? $0.title : $0.enTitle }
            let q = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if q.isEmpty { return address }
            return address.filter { key($0).localizedCaseInsensitiveContains(q) }
        }
  
    
    
    var body: some View {
        VStack{
            // MARK: - DONE BUTTON
            HStack{
                HStack{
                Image(systemName: "magnifyingglass")
                    
                        
                    TextField("",text:$searchText,axis:.vertical)
                        .lineLimit(1)
                        
                }
                .modifier(GlassEffectTextFieldModifier())
                
                
                Spacer()
                                Button(action: {
                                  
                    Task{
                        
                        
                        await api.getBibleResult(selectedBible?.initial ?? "", selectedBible?.title ?? "", chapter: String(chapter),enTitle: selectedBible?.enTitle ?? "",lang:lang)
                            
                         
                       
                            openResult = true
                        
                            
                        
                        
                       
                        
                    }
                              
                }) {
                    
                    Text(openResult ? "HOLD":"DONE")
                        .font(Font.semi20)
                        .foregroundColor(Color.customText)
                }
                .disabled(selectedBible?.title == "선택하기")
            }//:HSTACK
            .padding(.top,20)
            
            // MARK: - PICKERS(bible)
            HStack{
                VStack {
                    Picker("성경",selection:$selectedBible){
                        ForEach(filteredBibles,id:\.id){
                            a in
                            
                            Text(lang ? a.title : a.enTitle).tag(a)
                                .font(Font.semi20)
                                .foregroundColor(Color.customText)
                        }
                    }
                }//:PICKER(title)
                .pickerStyle(.wheel)
                .accentColor(Color.customBackground)
//                .colorScheme(.light) // 라이트 모드로 강제 설정하여 색상이 잘 보이도록
                
                Divider()
                    .background(Color.customBackground)
                
                // MARK: - PICKER(CHAPTER)
                Picker("장",selection:$chapter){
                    ForEach(1...(selectedBible?.pg ?? 1),id:\.self){
                        ch in
                        if selectedBible?.title == "선택하기"{
                            Text("")
                        }else{
                            Text("\(ch) 장").tag(ch)
                                .font(Font.semi20)
                                .foregroundColor(Color.customText)
                        }
                       
                        
                         
                        
                       
                    }
                }//:PICKER(CHAPTER)
                .pickerStyle(.wheel)
//                .accentColor(Color.customBackground)
//                .colorScheme(.light) // 라이트 모드로 강제 설정하여 색상이 잘 보이도록
                
                Spacer()
            }//:HSTACK
            
        }//:VSTACK
        .onChange(of: searchText) { oldValue, newValue in
            let key: (Bible) -> String = { lang ? $0.title : $0.enTitle }
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            let hits = address.filter { key($0).localizedCaseInsensitiveContains(trimmed) }
            if hits.count == 1 {            // 유일하게 걸리면
                selectedBible = hits.first  // 자동 선택
            }
        }

        .sheet(isPresented: $openResult) {
            BibleResultView()
          
         
        }
        
        .padding(.horizontal,16)
//      .background(Color.customText)
        .font(Font.semi20)
        .foregroundColor(Color.customBackground)
//        .preferredColorScheme(.light) // 전체 뷰를 라이트 모드로 설정
        .modifier(GlassEffectSheetModifier())
    }
}







#Preview {
let dataService = DataService()

return BibleFormView()

    .environment(dataService)

}
