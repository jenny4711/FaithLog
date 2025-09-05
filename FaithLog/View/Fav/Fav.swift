//
//  Fav.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/30/25.
//

import SwiftUI
import SwiftData

struct Fav: View {
    @Query private var favs:[FavVerse]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var setAlert:Bool = false
    let colums = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        NavigationStack{
            ZStack{
                Color.customBackground
                    .ignoresSafeArea()
                    .font(Font.heavy25)
                    .foregroundColor(Color.colorText)
                VStack{
                     // MARK: - LEFT BTN
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                            
                                .tint(Color.customText)
                        }
                        Spacer()
                        
                        
                        
                        
                    }//:HSTACK(BTN)
                    

                    .padding(.leading,16)
                     // MARK: - TITLE
                    VStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image("logo")
                                .padding(.bottom, 20)
                        }
                        Text("Favorite List")
                            .font(Font.heavy25)
                            .foregroundColor(Color.customText)
                        
                    }//:VSTACK(logo and title)
                    
                     // MARK: - LIST
                    ScrollView{
                        LazyVGrid(columns:colums,spacing:5){
                            ForEach(favs,id:\.self){
                                item in
                                NavigationLink{
                                    FavDetailView(fav: item, content: item.content)
                                }label:{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.customText)
                                        .frame(height:180)
                                        .overlay {
                                            
                                           
                                            VStack{
                                                Text("\(item.title)-\(item.chapter)장")
                                                    .foregroundColor(Color.customBackground)
                                                Text("\(item.content)")
                                                    .lineLimit(3)
                                                    .truncationMode(.tail)
                                                    .foregroundColor(item.content.containsSpecialCharacter ? Color.customBackground :Color.red)
                                                    .padding()
                                            }
                                          
                                        }
                                        .padding(.vertical,16)
                                }
                                
                                
                                
                            }//:loop
                            
                        }
                       
                        

                    }//:SCROLLview
                    
                  
                      

                    
                    
                    .scrollIndicators(.hidden)
                    
                }//:VSTACK
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                         Button(action: {
                             setAlert = true
                         }) {
                               ZStack{
                                    Circle()
                                        .frame(width: 60,height:60)
                                        .tint(Color.customText)
                                    Image(systemName: "bell")
                                        .resizable()
                                        .frame(width:24,height:24)
                                        .foregroundColor(Color.customBackground)
                                                    }
                                                }
                    }//:HSTACK(BTN)
                    

                }//:VSTACK(BTN)
                

                

            }//:ZSTACK
            .sheet(isPresented:$setAlert){
                Text("Alert!")
                
            }

            
            .padding(.horizontal,24)
         
            
        }
        .background(Color.customBackground)
        .navigationBarBackButtonHidden(true)
    }
}








#Preview {
    Fav()
}
