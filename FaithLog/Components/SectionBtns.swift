//
//  SectionBtns.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import SwiftUI

struct SectionBtns: View {
    let title:String
    var body: some View {
       
        ZStack{
           RoundedRectangle(cornerRadius: 16)
                .fill(Color.colorText)
                .frame(width:100,height:100)
            Text(title)
                .font(Font.black18)
                .foregroundColor(Color.colorBackground)
        }
    }
}

#Preview {
    SectionBtns(title: "QT")
}
