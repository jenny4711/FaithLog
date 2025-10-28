//
//  FavDoneView.swift
//  FaithLog
//
//  Created by Ji y LEE on 10/10/25.
//

import SwiftUI

struct FavDoneView: View {
    var fav:FavVerse
    var parts:[String]
    var body: some View {
        VStack{
          
            Text("완료! 모든 문단을 맞췄어요 🎉")
                .font(.headline)
                .foregroundColor(.green)
                .padding(.top,100)
                .padding(.bottom,20)
            HStack{
                Text(fav.title)
                Text("\(fav.chapter)장 \(fav.verse)절")
            }
           
            
            
            VStack{
               
                ForEach(parts,id:\.self){
                    item in
                    Text("\(item)")
                }
              
            }
           
            Spacer()
        }
        .background(
            Color.customBackground
        )
    
      
        
    }
}

#Preview {
    FavDoneView(fav: FavVerse(title: "잠언", lang: "kr", chapter: "12", verse: "28", content: "28 의로운 사람의 길에는 생명이 있지만 미련한 사람의 길은 죽음으로 이끈다", date: Date()), parts: ["28 의로운 사람의 길에는 생명이 있지만","미련한 사람의 길은 죽음으로 이끈다"])
}
