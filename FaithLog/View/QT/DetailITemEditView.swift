//
//  DetailITemEditView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/21/25.
//

import SwiftUI

struct DetailITemEditView: View {
    @Binding var isEdint: Bool
    @Binding var editField: String
    var item: String
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(Font.heavy25)
                Spacer()
            }
            .padding(.bottom, 10)
            if title == "제목"{
                TextField("",text: $editField,axis:.vertical)
                    .frame(height:40)
                    .lineLimit(1...3)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Color.customText)
                  
                    .cornerRadius(8)
                    .padding(.horizontal,16)
                
            }else{
                TextEditor(text: $editField)
                    .frame(minHeight: 150, maxHeight: 500)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .scrollContentBackground(.hidden)
                    .font(Font.reg18)
//                    .accentColor(Color.customText)
                    .foregroundColor(Color.customBackground)
                    .background(Color.customText)
                    .cornerRadius(8)
            }
           
            
            
        }
        .onAppear {
            // 기존 내용을 editField에 설정
            editField = item
            print("DetailITemEditView appeared with item: \(item)")
            print("editField set to: \(editField)")
        }
        .padding(.trailing, 20)
    }
}

#Preview {
    DetailITemEditView(isEdint: .constant(false), editField: .constant(""), item:"묵상", title: "묵상")
}
