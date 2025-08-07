//
//  Onboarding.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI

struct Onboarding: View {
    @State private var showBibleForm:Bool = false
    var body: some View {
        NavigationStack {
            ZStack{
                Color(Color.customBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Image("logo")
                        .resizable()
                        .frame(width:100,height:100)
                        .padding(.bottom,20)
                    HStack{
                        NavigationLink{
                            QtView()
                        }label:{
                           SectionBtns(title: "QT")
                            
                        }//: NavigationLink(QTBTN)
                        
                        Button(action: {
                            showBibleForm = true
                        }) {
                            SectionBtns(title: "Bible")
                        }//:BTN(BIBLE)
                        

                        
                    }//:HSTACK(qt,bible)
                    

                    
                }
                .sheet(isPresented: $showBibleForm) {
                    BibleFormView()
                        .presentationDetents([.fraction(0.3)])
                    
                }
                
              
               
                
            }
        }
    }
}

#Preview {
    Onboarding()
}
