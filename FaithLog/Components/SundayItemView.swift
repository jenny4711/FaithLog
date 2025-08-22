//
//  SundayItemView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//

import SwiftUI

struct SundayItemView: View {
    var item:Sunday?
    var body: some View {
        VStack{
            Text(item?.title ?? "")
                .font(Font.bold15)
            
          
        }
        .frame(maxWidth:.infinity)
        .padding()
        .background(Color.customText)
        .foregroundColor(Color.customBackground)
        .cornerRadius(15)
    }
}

#Preview {
    SundayItemView()
}
