//
//  QtFormView.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import SwiftData
struct QtFormView: View {
    @State private var openBibleForm : Bool = false
    @State var newQt:Qt?
    @State private var title:String = ""
    @State  var medit:String = ""
    @State var application:String = ""
    @State var pray:String = ""
    @State var paths:String = "medit"
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(DataService.self) var api
    var body: some View {
        ZStack {
            Color.colorBackground
                .ignoresSafeArea()
            
             // MARK: - 성경보기 버튼
            VStack(spacing:16) {
                HStack{
                    Spacer()
                    Button(action: {
                        let item = Qt()
                        item.title = title
                        item.medit = medit
                        item.appl = application
                        item.pray = pray
                        item.content = api.selectedBible
                        item.date = Date()
                        
                        // 안전한 주소 생성
                        if !api.selectedBible.isEmpty {
                            let firstVerse = api.selectedBible[0]
                            let lastVerse = api.selectedBible.last!
                            item.bible = firstVerse.title
                            item.address = "\(firstVerse.title) \(firstVerse.chapter)장 \(firstVerse.verse)절-\(lastVerse.verse)절"
                        } else {
                            item.address = "선택된 성경 구절 없음"
                        }
                        
                        context.insert(item)
                        api.selectedBible = []
                        
                        dismiss()
                    }) {
                        Text("저장")
                            .foregroundColor(Color.customText)
                    }
                }
                .padding(.horizontal,24)
                ScrollView{
                    Button(action: {
                        openBibleForm = true
                    }) {
                        Rectangle()
                            .frame(height:50)
                            .tint(Color.colorText)
                            .cornerRadius(5)
                            .overlay {
                                Text("성경보기")
                                    .foregroundColor(Color.colorBackground)
                            }
                    }//:BUTTON
                    
                    
                    
                    // MARK: - 타이틀(title)
                    
                    
                    VStack(alignment:.leading) {
                        Text("Title")
                            
                            .font(Font.bold15)
                            .foregroundColor(Color.colorText)
                        HStack {
                            TextField("",text:$title,axis:.vertical)
                                .frame(height:60)
                                .lineLimit(1...3)
                                .textFieldStyle(PlainTextFieldStyle())
//                                .background(Color.colorText)
                                .foregroundColor(Color.customBackground)
                        
                                .padding(.leading,16)
                                
                        }
                        .background(Color.customText)
                        .cornerRadius(10)
                       
                    }//:VStack(title)
                    

                    
                    
                    
                    // MARK: - content
                    if api.selectedBible.isEmpty {
                        EmptyView()
                    } else{
                        ShowBibleView()
                    }
                   
                    if paths == "medit"{
                        // MARK: - 묵상하기(medit)
                       QtTextFieldView(item: $medit, title: "묵상")
                    }
                    if paths == "appl"{
                        // MARK: - 적용(appl)
                        QtTextFieldView(item: $application, title: "적용")
                    }
                    if paths == "pray"{
                        
                          // MARK: - 기도(pray)
                          QtTextFieldView(item: $pray, title: "기도")
                    }
                  

                  
                    
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            if paths == "medit"{
                                paths = "appl"
                            }else if paths == "appl"{
                                paths = "pray"
                            }else{
                                paths = "medit"
                            }
                        }) {
                            Circle()
                                .frame(width:70)
                                .tint(Color.customText)
                                .overlay{
                                    VStack {
                                        Text(
                                            paths == "medit" ? "적용" :(paths == "appl" ? "기도" :  "묵상")
                                        )
                                       
                                        Text("작성하기")
                                    }
                                    .font(Font.bold15)
                                    .foregroundColor(Color.customBackground)
                                    
                                }
                            
                            
                        }
                      
                    }
                    
                    
                    
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal,24)
                .background(Color.colorBackground)
            }
            .padding(.top,20)
        }
        .sheet(isPresented: $openBibleForm) {
            BibleFormView()
                .presentationDetents([.fraction(0.3)])
            
        }
    }
}







struct ShowBibleView: View {
    @Environment(DataService.self) var api
    var body: some View {
        VStack{
            HStack {
                Text("Content")
                    .font(Font.bold15)
                    .foregroundColor(Color.colorText)
                Spacer()
            }
            VStack(alignment:.leading){
                
                ScrollView{
                    ForEach(api.selectedBible){
                        b in
                        Text(b.content)
                            .font(Font.black18)
                            .foregroundColor(Color.customBackground)
                            .padding(.vertical,8)
                    }
                }
                .scrollIndicators(.hidden)
                .frame(height:250)
                .padding()
                
            }
          
            .frame(maxWidth:.infinity,maxHeight:300)
            .background(Color.customText)
            .cornerRadius(10)
        }
    }
}
#Preview {
    let dataService = DataService()
    return QtFormView()
        .environment(dataService)
}
