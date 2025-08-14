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
            }
            .padding(.leading,20)
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
                      Text(item?.title ?? "")
                          .font(Font.light26)
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
                  DetailItemView(item:item?.medit ?? "", title:"묵상")
              }
              
          
              
              
                // MARK: - appl
              if item?.appl == "" {
                 EmptyView()
              }else{
                  DetailItemView(item: item?.appl ?? "", title: "적용")
              }
         
          
                // MARK: - pray
              if item?.pray == "" {
                  EmptyView()
              }else{
                  DetailItemView(item: item?.pray ?? "", title: "기도")
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
    QtDetail()
}
