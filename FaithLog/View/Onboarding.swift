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
                
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width:100,height:100)
//                        .padding(.bottom,20)
                    Spacer()
                    
                    HStack{
                        NavigationLink{
                            QtView()
                        }label:{
                            
                            NavigationBtn(title:"QT")
                            
                        }//:NavigationLink(QT)
                        
                        NavigationLink{
                            BibleView()
                        }label:{
                            NavigationBtn(title: "BIBLE")
                        }//:NavigationBTN(THANKS)
                        

                    }//:HSTACK(QT,THABKS)
                    Spacer()

                }//:VSTACK
                

               
                

               
                
            }
        }
    }
}

#Preview {
    Onboarding()
}
