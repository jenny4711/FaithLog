//
//  QtDetail.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI

struct QtDetail: View {
    var item :Qt?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State  var isEdit:Bool = false
    @State  var edMedit:String = ""
    @State var edAppl:String = ""
    @State  var edPray:String = ""
    @State var edTitle:String = ""
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    
    
    // 첫 번째 숫자를 추출하는 헬퍼 함수
    private func extractFirstNumber(from text: String) -> Int {
        let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
        return numbers.first ?? 0
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack{
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                      
                        .tint(Color.customText)
                }
             Spacer()
                
                Button(action: {
                    if isEdit {
                        // 저장 로직
                        if let qtItem = item {
                            if edTitle != ""{
                                qtItem.title = edTitle
                            }
                            if edMedit != ""{
                                qtItem.medit = edMedit
                            }
                            if edAppl != ""{
                                qtItem.appl = edAppl
                            }
                            if edPray != ""{
                                qtItem.pray = edPray
                            }
                           
                            
                        
                            try? context.save()
                        }
                        isEdit = false
                    } else {
                        isEdit = true
                    }
                }) {
                    Text(isEdit ? "Save" : "Edit")
                        .foregroundColor(Color.customText)
                }
            }
            .padding(.horizontal,20)
            ScrollView(showsIndicators:false){
                
                
                // MARK: - bible
                
              HStack{
                  
                  Text(item?.bible ?? "")
                      .font(Font.black36)
                  Spacer()
              }
              .padding(.bottom,10)
             // MARK: - title
              HStack{
                  VStack{
                      
                      if isEdit {
                          DetailITemEditView(isEdint: $isEdit, editField: $edTitle, item: item?.title ?? "", title: "제목")
                      }else{
                          Text(item?.title ?? "")
                              .font(Font.semi20)
                      }
                      
                      
                     
                  }
                  .frame(maxWidth:UIScreen.main.bounds.width/2,alignment:.leading)
                
                  Spacer()
              }

              
                // MARK: - address
              HStack {
                  Text(item?.address ?? "")
                      .font(Font.light20)
                  Spacer()
              }
              .padding(.bottom,10)
                
                
                 
                
               
             
             
                // MARK: - bible content
                if lang {
                    HStack {
                         Text("성경 구절")
                             .font(Font.heavy25)
                        Spacer()
                     }
                    
                     ScrollView{
                         VStack(alignment:.leading){
                             
                             ForEach((item?.content ?? []).sorted { first, second in
                                 // "17 훈계를 지키는 사람은..." 형태에서 첫 번째 숫자를 추출하여 정렬
                                 let firstContent = first.content
                                 let secondContent = second.content
                                 
                                 // 첫 번째 숫자를 찾아서 정렬
                                 let firstNumber = extractFirstNumber(from: firstContent)
                                 let secondNumber = extractFirstNumber(from: secondContent)
                                 
                                 return firstNumber < secondNumber
                             }, id: \.id) { c in
                                 Text("\(c.content)")
                                     .padding(.bottom,10)
                             }
                             .padding(.vertical,5)
                         }
                         
                         
                         
                         
                         
                         
                     }//:ScrollView(BIBLE CONTENT)
                     .frame(maxHeight:300)
                     .padding()
                     .padding(.vertical,10)
                     .scrollIndicators(.hidden)
                    
                }else {
                    EmptyView()
                }
            
                
                
                
                

               
          
                // MARK: - med
              if item?.medit == "" {
                  if isEdit{
                      DetailITemEditView(isEdint: $isEdit, editField: $edMedit, item: item?.medit ?? "", title: "묵상")
                  }else{
                      EmptyView()
                  }
                 
              }else{
         
                  if isEdit {
                      DetailITemEditView(isEdint: $isEdit, editField: $edMedit, item: item?.medit ?? "", title: "묵상")
                  }else{
                      DetailItemView(item:item?.medit ?? "", title:"묵상")
                  }
               
                  
              
              }
              
          
              
              
                // MARK: - appl
              if item?.appl == "" {
                  
                  if isEdit{
                      DetailITemEditView(isEdint: $isEdit, editField: $edAppl, item: item?.appl ?? "", title: "적용")
                  }else{
                      EmptyView()
                  }
                
              }else{
                  if isEdit{
                      DetailITemEditView(isEdint: $isEdit, editField: $edAppl, item: item?.appl ?? "", title: "적용")
                  }else{
                      DetailItemView(item: item?.appl ?? "", title: "적용")
                  }
                
              }
         
          
                // MARK: - pray
              if item?.pray == "" {
                  if isEdit {
                      DetailITemEditView(isEdint: $isEdit, editField: $edPray, item: item?.pray ?? "", title: "기도")
                  }else{
                      EmptyView()
                  }
                  
                  
                 
              }else{
                  if isEdit{
                      DetailITemEditView(isEdint: $isEdit, editField: $edPray, item: item?.pray ?? "", title: "기도")
                  }else{
                     
                     DetailItemView(item: item?.pray ?? "", title: "기도")
                  }
              
              }
             
                Spacer()
                
            }//: ScrollView
          .padding(.leading,20)
        
        }//:VSTACK
        .frame(maxWidth:.infinity,alignment:.leading)
        .background(Color.customBackground)
        .foregroundColor(Color.customText)
        .navigationBarBackButtonHidden(true)
   

       
    }
}







#Preview {
    QtDetail(edMedit:"" , edAppl: "", edPray: "")
}
