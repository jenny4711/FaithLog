//
//  DetailItemView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/13/25.
//

import SwiftUI

struct DetailItemView: View {
    var item:String
    var title:String
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(Font.heavy25)
                Spacer()
            }
            .padding(.bottom,10)
            VStack(alignment:.leading){
                Text(item)
                    .font(Font.med20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth:.infinity)
        }
        .padding(.bottom,16)
    }
}

//#Preview {
//    DetailItemView()
//}
