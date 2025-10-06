//
//  QtTextFieldView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/8/25.
//

import SwiftUI

struct QtTextFieldView: View {
    @Binding var item:String
   var title:String = "" 
    var body: some View {
        VStack{
            HStack {
                Text(title)
                    .font(Font.bold15)
                    .foregroundColor(Color.colorText)
                Spacer()
            }
            
            VStack(alignment:.leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height:400)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    TextEditor(text: $item)
                        .frame(minHeight:150, maxHeight: 400)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        
                        .scrollContentBackground(.hidden)
                        .font(Font.reg18)
                        .accentColor(Color.customText)
                        .foregroundColor(Color.customBackground)

                       
                    
                    if item.isEmpty {
                        Text("묵상 내용을 입력하세요...")
                            .foregroundColor(Color.gray.opacity(0.6))
                            .font(Font.reg12)
                            .padding(.top, 16)
                            .padding(.leading, 16)
                            .allowsHitTesting(false)
                    }
                }
            }
            .foregroundColor(Color.colorText)
        }
    }
}

#Preview {
    @Previewable @State var meditation: String = ""
    return QtTextFieldView(item: $meditation, title: "묵상")
}
