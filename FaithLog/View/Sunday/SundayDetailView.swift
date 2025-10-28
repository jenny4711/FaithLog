//
//  SundayDetailView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//



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
    @State private var openImg:Bool = false
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
                                .foregroundColor(Color.customText)
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
                
                HStack{
                    if let data = item?.photo,let uiImg = UIImage(data:data){
                        Button(action: {
                            openImg = true
                        }) {
                            Image(uiImage: uiImg)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth:.infinity)
                                .frame(height:isEdit ? 300 :350)
                                .clipped()
                                .cornerRadius(20)
                                .padding(.horizontal,20)
                                .padding(.bottom,20)
                        }
                    }
                }
                
                
                if isEdit{
                    DetailITemEditView(isEdint: $isEdit, editField: $edNote, item: item?.note ?? "", title: "")
                }else{
                    ScrollView{
                        MarkdownStyledText(markdown: item?.note ?? "")
    
                            .foregroundColor(Color.customText)
                    }//:SCROLLVIEW
                    .scrollIndicators(.hidden)
                }

                

            }
            .background(Color.customBackground)
        }//:ZSTACK
        .sheet(isPresented:$openImg){
            ImgeDetailView(item: item)
                .presentationDetents([.fraction(0.8)])
        }
        .onAppear{
            edNote = item?.note ?? "Empty"
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SundayDetailView()
}






