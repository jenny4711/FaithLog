//
//  SundayView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//

import SwiftUI
import SwiftData
struct SundayView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var openForm:Bool = false
    @Query(sort:\Sunday.date,order:.reverse) private var Sundays:[Sunday]
    var body: some View {

        NavigationStack{
            VStack {
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
                            Text("Sunday List")
                                .font(Font.heavy25)
                                .foregroundColor(Color.customText)
                            
                        }//:VSTACK(logo and title)
                        
                        // MARK: - LIST
                        List {
                            ForEach(Sundays) { item in
                                NavigationLink {
                                    SundayDetailView(item:item)
                                } label: {
                                   SundayItemView(item: item)
                                       
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
                        }//:LIST
                        

                        .listStyle(PlainListStyle())
                        .listRowSpacing(12) // row 사이 간격 추가
                        .listRowSeparator(.hidden) // 기본 구분선 숨기기
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)) // 상하 여백 추가
                        .background(Color.customBackground) // 전체 List 배경색
                      
                
                        
                        
                        .padding(.horizontal,24)
                        
                        
                        
                    }
                    
                    
                    
                }//:ZSTACK
                // MARK: - PlusBtn
               HStack{
                   Spacer()
                   PlusBtnView(openForm: $openForm)
               }
               .padding(.horizontal,24)
            }//:VSTACK
            .sheet(isPresented: $openForm, content: {
                SundayFormView()
            })
            .background(Color.customBackground)

           
        
         
         
        }//:NAVITATIONSTACK
    
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SundayView()
}
