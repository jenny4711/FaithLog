//
//  NavigationBtn.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/1/25.
//

import SwiftUI

struct NavigationBtn: View {
    let title:String
    var body: some View {
        VStack{
           
            ZStack {
                Rectangle()
                    .fill(Color.colorText)
                    .frame(width:100,height:100)
                    .cornerRadius(16)
                Text(title)
                    .font(Font.semi20)
                    .foregroundColor(Color.colorBackground)
            }
           
        }
    }
}

#Preview {
    NavigationBtn(title: "QT")
}
