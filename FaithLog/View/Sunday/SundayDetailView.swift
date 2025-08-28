//
//  SundayDetailView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//

import SwiftUI

struct SundayDetailView: View {
    var item :Sunday?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var isEdit:Bool = false
    @State private var edNote:String = ""
    var body: some View {
        ZStack(alignment:.leading){
            Color.customBackground
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                          
                            .tint(Color.customText)
                    }
                 Spacer()
                    if isEdit{
                        Button(action: {
                            
                            if let sunday = item{
                                sunday.note = edNote
                                try?context.save()
                                isEdit = false
                            }
                        }) {
                            Text("Save")
                        }
                    }else{
                        Button(action: {
                           
                            
                              isEdit = true
                            
                        }) {
                            Text("Edit")
                                .foregroundColor(Color.customText)
                        }
                    }
                       
                    
                }
                .padding(.horizontal,20)
                HStack{
                    Text(item?.title ?? "")
                        .font(Font.semi20)
                        .foregroundColor(Color.customText)
                }
                
                if isEdit{
                    DetailITemEditView(isEdint: $isEdit, editField: $edNote, item: item?.note ?? "", title: "")
                }else{
                    ScrollView{
                        MarkdownStyledText(markdown: item?.note ?? "")
    //                    Text(item?.note ?? "")
                            .foregroundColor(Color.customText)
                    }//:SCROLLVIEW
                    .scrollIndicators(.hidden)
                }

                

            }
            .background(Color.customBackground)
        }//:ZSTACK
        .onAppear{
            edNote = item?.note ?? "Empty"
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SundayDetailView()
}
