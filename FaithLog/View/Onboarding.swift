//
//  Onboarding.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import UserNotifications



struct Onboarding: View {
    @State private var showBibleForm:Bool = false
    @State var isKR : Bool = false
//    @State private var setAlarm:Bool = false
    @State private var isAnimated:Bool = false
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                ZStack{
                    Color(Color.customBackground)
                        .ignoresSafeArea()
                    
                    VStack{
                        Image("logo")
                            .resizable()
                            .frame(width:100,height:100)
                           .padding(.top,50)
                        Spacer()
                        HStack{
                            NavigationLink{
                                QtView()
                            }label:{
                                SectionBtns(title:lang ? "묵상" : "QT")
                                
                            }//: NavigationLink(QTBTN)
                            
                            Button(action: {
                                showBibleForm = true
                            }) {
                                SectionBtns(title:lang ? "성경" : "BIBLE")
                            }//:BTN(BIBLE)
                            
                           
                            
                            
                        }//:HSTACK(qt,bible)
                       
                        
                        HStack{
                            NavigationLink{
                                SundayView()
                            }label:{
                                SectionBtns(title:lang ? "주일 예배" : "Sunday")
                                
                            }//: NavigationLink(Sunday)
                            
                            
                            NavigationLink{
                                Fav()
                                
                            }label:{
                                SectionBtns(title:lang ? "마음의구절" : "Fav Verse")
                            }
                            
                            
                            
                        }
                        
                        Spacer()
                        
                    }
                    .sheet(isPresented: $showBibleForm) {
                        BibleFormView()
                            .presentationDetents([.fraction(0.3)])
                            
                    }
                    
                   
                   
                    
                }
                HStack{
                    Spacer()
                    Button(action: {
                        isKR.toggle()
                        if isKR{
                            seleLang = "KR"
                        }else{
                            seleLang = "EN"
                        }
                        

                    }) {
                        ZStack{
                            
                            Circle()
                                .frame(width: 60,height:60)
                                .tint(Color.customText)
                            Text(lang ? "US" : "KR")
                                .font(Font.semi20)
                                 .foregroundColor(Color.customBackground)
                              
                        }
                        
                    }//:Button
                    .modifier(GlassEffectCircleBtnModifier())
                }
                .padding(.horizontal,16)
               
                

                
            }//:VSTACK



            .background(
                Color.customBackground
            )
        }//:NAVIGATE STACK
        

    }
}



#Preview {
    Onboarding()
}
