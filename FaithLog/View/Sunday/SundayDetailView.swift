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
    var body: some View {
        ZStack{
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
                }
                .padding(.leading,20)
                
                ScrollView{
                    MarkdownStyledText(markdown: item?.note ?? "")
//                    Text(item?.note ?? "")
                        .foregroundColor(Color.customText)
                }
            }
            .background(Color.customBackground)
        }//:ZSTACK
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SundayDetailView()
}
