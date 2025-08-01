//
//  Onboarding.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        NavigationStack {
            ZStack{
                Color(Color.customBackground)
                    .ignoresSafeArea()
                NavigationLink{
                    QtView()
                }label:{
                    VStack{
                        Image("logo")
                            .resizable()
                            .frame(width:100,height:100)
                            .padding(.bottom,20)
                        Text("GET START")
                            .font(Font.black30)
                            .foregroundColor(Color.colorText)
                    }
                    
                }
               
                
            }
        }
    }
}

#Preview {
    Onboarding()
}
