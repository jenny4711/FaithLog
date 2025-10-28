//
//  Modifiers.swift
//  FaithLog
//
//  Created by Ji y LEE on 10/14/25.
//

import SwiftUI

struct GlassEffectBtnModifier2:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(.plain)
                .glassEffect(.
                             regular.tint(Color(Color.customText).opacity(0.4))
                             
                        
                )
        } else {
           content
                .foregroundColor(Color.customText)
        }
    }
}

struct IntroTextModifier:ViewModifier{
    func body(content:Content)->some View{
        content
            .font(Font.light15)
            .padding(.horizontal,24)
            .padding(.vertical,10)
            .foregroundColor(Color.customText)
            .lineSpacing(3)
    }
}

struct GlassEffectBtnModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(.plain)
                .glassEffect(.
                             regular.tint(Color(Color.customText).opacity(0.4))
                             
                        
                )
        } else {
           content
                .tint(Color.customText)
        }
    }
}
struct GlassEffectTextEditerModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS  26.0, *){
            content
            
                .glassEffect(in: RoundedRectangle(cornerRadius: 10))
        }else{
            content
                .background(Color.customText)
        }
    }
}


struct GlassEffectTextEditerModifier2:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS  26.0, *){
            content
                .frame(minHeight: 150, maxHeight: 500)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .scrollContentBackground(.hidden)
                .font(Font.reg18)
//                    .accentColor(Color.customText)
                .foregroundColor(Color.customText)
//                .background(Color.customText)
                .cornerRadius(8)
            
                .glassEffect(in: RoundedRectangle(cornerRadius: 10))
        }else{
            content
                .frame(minHeight: 150, maxHeight: 500)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .scrollContentBackground(.hidden)
                .font(Font.reg18)
//                    .accentColor(Color.customText)
                .foregroundColor(Color.customBackground)
//                .background(Color.customText)
                .cornerRadius(8)
                .background(Color.customText)
        }
    }
}







struct GlassEffectTextFieldModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *){
            
            content .padding()
                .frame(height:60)
                .lineLimit(1...3)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color.customText)
                .glassEffect()
        }else{
            content
                .padding()
                .frame(height:60)
                .lineLimit(1...3)
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.colorText)
                .foregroundColor(Color.customText)
               
            
        }
    }
}

struct GlassEffectHStackModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *){
            content
        }else{
            content
                .background(Color.customText)
                .cornerRadius(10)
        }
    }
}

struct GlassEffectTextColorModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *){
            content
                .font(Font.bold15)
                .foregroundColor(Color.customOneTextLight)
        }else{
            content
                .font(Font.bold15)
                .foregroundColor(Color.customBackground)
        }
    }
}

struct GlassEffectSheetModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS  26.0, *){
            content
                .glassEffect(.regular,in:.capsule)
        }else{
            content
        }
    }
}

struct GlassEffectCircleBtnModifier:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS  26.0, *){
            content
                .buttonStyle(.plain)
                .glassEffect(.
                            clear.tint(Color(Color.customText).opacity(0.8))
                             
                        
                )
            
        }else{
            content
        }
    }
}

struct defaultGlassEffect:ViewModifier{
    func body(content:Content)->some View{
        if #available(iOS 26.0, *){
            content
                .glassEffect()
        }else{
            content
        }
    }
}
