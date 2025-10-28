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
//                modifier(GlassEffectTextFieldModifier())
//                .cornerRadius(50)
                    .frame(height:40)
                    .lineLimit(1...3)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Color.customText)
                  
                    .cornerRadius(8)
                    .padding(.horizontal,16)
                
            }else{
//                QtTextFieldView(item: $editField)
                TextEditor(text: $editField)
                    .modifier(GlassEffectTextEditerModifier2())
//                    .frame(minHeight: 150, maxHeight: 500)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    .scrollContentBackground(.hidden)
//                    .font(Font.reg18)
//                    .foregroundColor(Color.customBackground)
//                    .background(Color.customText)
//                    .cornerRadius(8)
            }
           
            
            
        }
        .onAppear {
            // 기존 내용을 editField에 설정
            editField = item
            print("DetailITemEditView appeared with item: \(item)")
            print("editField set to: \(editField)")
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DetailITemEditView(isEdint: .constant(false), editField: .constant(""), item:"묵상", title: "묵상")
}
