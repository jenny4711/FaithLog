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
          ScrollView{
                
                
                // MARK: - bible
                
              HStack{
                  
                  Text(item?.bible ?? "")
                      .font(Font.black36)
                  Spacer()
              }
             // MARK: - title
              HStack{
                  VStack{
                      
                      if isEdit {
                          DetailITemEditView(isEdint: $isEdit, editField: $edTitle, item: item?.title ?? "", title: "제목")
                      }else{
                          Text(item?.title ?? "")
                              .font(Font.light26)
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
              .padding(.bottom,56)
               
             
             
                // MARK: - bible content
          
                // MARK: - med
              if item?.medit == "" {
                  EmptyView()
              }else{
         
                  if isEdit {
                      DetailITemEditView(isEdint: $isEdit, editField: $edMedit, item: item?.medit ?? "", title: "묵상")
                  }else{
                      DetailItemView(item:item?.medit ?? "", title:"묵상")
                  }
               
                  
              
              }
              
          
              
              
                // MARK: - appl
              if item?.appl == "" {
                 EmptyView()
              }else{
                  if isEdit{
                      DetailITemEditView(isEdint: $isEdit, editField: $edAppl, item: item?.appl ?? "", title: "적용")
                  }else{
                      DetailItemView(item: item?.appl ?? "", title: "적용")
                  }
                
              }
         
          
                // MARK: - pray
              if item?.pray == "" {
                  EmptyView()
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
