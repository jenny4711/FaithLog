//
//  QtView.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import SwiftData
struct QtView: View {
    @State var openForm:Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query(sort:\Qt.date,order:.reverse) private var Qts:[Qt]
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.colorBackground
                    .ignoresSafeArea()
                
                
                    .font(Font.heavy25)
                    .foregroundColor(Color.colorText)
                VStack{
                
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                              
                                .tint(Color.customText)
                        }
                     Spacer()
                    }
                    .padding(.leading,16)
                    VStack{
                        Image("logo")
                            .padding(.bottom,20)
                        Text("Qt List")
                            .font(Font.heavy25)
                        
                    }//:VSTACK(logo and title)
                    .padding(.vertical,20)
                    .foregroundColor(Color.colorText)
                 List {
                      ForEach(Qts) { item in
                          NavigationLink {
                              QtDetail(item:item)
                          } label: {
                              QtListCellView(item: item)
                          }
                          .listRowBackground(Color.customBackground) // 각 셀 배경색
                          .swipeActions(edge:.trailing) {
                              Button(action: {
                                  context.delete(item)
                              }) {
                                  Image(systemName: "trash")
                              }
                              .tint(Color.customBackground)
                             
                          }
                       
                      }
                  }
                  .listStyle(PlainListStyle())
                  .background(Color.customBackground) // 전체 List 배경색

                 
                   
                    .padding(.horizontal,24)
                    HStack{
                        Spacer()
                        PlusBtnView(openForm: $openForm)
                    }
                    .padding(.trailing,24)
                }//:VSTACK(LIST)
                .background(Color.customBackground)
                
            }//:ZSTACK
            .sheet(isPresented: $openForm) {
                QtFormView()
            }
            

        }//:NAVIGATIONSTACK
        
        .navigationBarBackButtonHidden(true)
        
    }
}








 // MARK: - ListCell

struct QtListCellView: View {
    var item:Qt?
    var body: some View {
        VStack{
            Text(item?.title ?? "")
                .font(Font.bold15)
               
            Text(item?.address ?? "")
                .font(Font.reg12)
        }
        .frame(maxWidth:.infinity)
        .padding()
        .background(Color.customText)
        .foregroundColor(Color.customBackground)
        .cornerRadius(15)
    }
}


 // MARK: - plus  button$$

struct PlusBtnView: View {
    @Binding var openForm:Bool
    var body: some View {
        Button(action: {
            openForm = true
        }) {
            ZStack{
                Circle()
                    .fill(Color.customText)
                    .frame(width:70)
                
                Image(systemName: "plus")
                    .font(Font.black30)
                    .foregroundColor(Color.customBackground)
                    
            }
        }
        
    }
}







#Preview {
    QtView()
}
