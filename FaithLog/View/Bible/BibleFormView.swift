//
//  BibleFormView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI

struct BibleFormView: View {
    @State var openResult: Bool = false
    @Environment(DataService.self) var api
    @State var selectedBible: Bible?
    @State var chapter: Int = 1

    
    var body: some View {
        VStack{
            // MARK: - DONE BUTTON
            HStack{
                Spacer()
                                Button(action: {
                    Task{
                        await api.getBibleResult(selectedBible?.initial ?? "", selectedBible?.title ?? "", chapter: String(chapter))
                        openResult = true
                    }
                }) {
                    Text("DONE")
                        .font(Font.semi20)
                }
            }//:HSTACK
            .padding(.top,20)
            
            // MARK: - PICKERS(bible)
            HStack{
                VStack {
                    Picker("성경",selection:$selectedBible){
                        ForEach(address,id:\.id){
                            a in
                            Text(a.title).tag(a)
                                .font(Font.semi20)
                        }
                    }
                }//:PICKER(title)
                .pickerStyle(.wheel)
                .accentColor(Color.customBackground)
                .colorScheme(.dark) // 다크 모드로 강제 설정
                
                Divider()
                
                // MARK: - PICKER(CHAPTER)
                Picker("장",selection:$chapter){
                    ForEach(1...(selectedBible?.pg ?? 1),id:\.self){
                        ch in
                        Text("\(ch) 장").tag(ch)
                            .font(Font.semi20)
                    }
                }//:PICKER(CHAPTER)
                .pickerStyle(.wheel)
                .accentColor(Color.customBackground)
                .colorScheme(.dark) // 다크 모드로 강제 설정
                
                Spacer()
            }//:HSTACK
            
        }//:VSTACK
        .sheet(isPresented: $openResult) {
            BibleResultView()
        }
        .padding(.horizontal,16)
        .background(Color.customText)
        .font(Font.semi20)
        .foregroundColor(Color.customBackground)
    }
}


//#Preview {
//    BibleFormView( api: DataService())
//}
