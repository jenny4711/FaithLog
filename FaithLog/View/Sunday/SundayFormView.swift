//
//  SundayFormView.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct SundayFormView: View {
    @State  var isEdit:Bool = true
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var newSunday = Sunday()
    @State private var title:String = ""
    @State private var newNote:String = ""
    @StateObject private var askAi = AskAI()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    let item = Sunday()
                    item.title = title
                    item.note = newNote
                    item.photo = newSunday.photo
                    context.insert(item)
                    dismiss()
                    
                }) {
                    Text("저장")
                        .padding(.trailing,16)
                        .padding(.top,24)
                        .foregroundColor(Color.customText)
                }
            }
//            .padding(.top,24)
            
            Button(action: {
                dismiss()
            }) {
                Image("logo")
                    .padding(.vertical, 15)
            }
            if lang{
                Text("은혜의 순간을 사진에만 묻어두지 마세요. 한 번의 불러오기만으로 텍스트가 되고, 원본 사진과 함께 언제든 찾아볼 수 있어요. 필요한 부분은 저장 전에 가볍게 손봐도 좋아요.")
                    .modifier(IntroTextModifier())
                    .padding(.bottom,10)
                
            }else{
                Text("Don’t let grace stay locked in a photo. With one import, your notes become text and the original image is kept alongside it, ready whenever you return. Make quick edits before saving if you like.")
                    .modifier(IntroTextModifier())
                    .padding(.bottom,10)
            }
          
            ScrollView{
               
                
                
              
                
                VStack {
                    
                    // MARK: - 타이틀(title)
                    
                    
                    VStack(alignment:.leading) {
                        Text("Title")
                        
                            .font(Font.bold15)
                            .foregroundColor(Color.colorText)
                        HStack {
                            TextField("",text:$title,axis:.vertical)
                                .modifier(GlassEffectTextFieldModifier())
                                .cornerRadius(50)
                            
                            
                        }
                        
                       
                        
                        
                    }//:VStack(title)
                    .padding(.horizontal,24)
                    .padding(.bottom, 24) // 타이틀 아래 간격 추가
                    
                    
                    if let imgData = newSunday.photo, !imgData.isEmpty {
                        if let img = UIImage(data: imgData) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                                .padding(.top)
                        }
                    } else {
                        //MARK: -photo picker
                        ZStack{
                            
                            Circle()
                                .frame(width: 80,height:80)
                                .modifier(GlassEffectBtnModifier2())
                            //                            .foregroundColor(Color.customText)
                            
                            
                            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                                Label("", systemImage: "photo.badge.plus")
                                    .foregroundColor(Color.customBackground)
                                
                                
                            }
                            .listRowSeparator(.hidden)
                            
                        }//:ZSTACK
                        .padding(.bottom, 24) // 사진 선택기 아래 간격 추가
                        
                    }
                    
                    
                    
                    VStack{
//                        QtTextFieldView(item: $newNote)
                        TextEditerView(item: $newNote)
                        
                        
                        Spacer()
                        
                    }
                    .onAppear{
                        newNote = newSunday.note
                    }
                    
                    .frame(maxWidth:.infinity)
                    .background(Color.customBackground)
                    .padding(.horizontal,16)
                    .onChange(of: photosPickerItem) { _, newValue in
                        Task {
                            
                            guard let item = newValue,
                                  let data = try? await item.loadTransferable(type: Data.self) else {
                                print("Failed to load image data")
                                return
                            }
                            
                            await MainActor.run {
                                newSunday.photo = data
                                askAi.isLoading = true
                            }
                            
                            
                            let note = await askAi.recognizeTextAsync(from: data)
                            await MainActor.run {
                                newSunday.note = note
                                newNote = note
                                askAi.isLoading = false
                            }
                            
                            
                        }//:TASK
                        
                        
                    }//:ONCHANGE
                }//:VSTACK
                .background(Color.customBackground)
                
            }
            
        }
        .background(Color.customBackground)
    }
    
}
    
    

struct TextEditerView: View {
    @Binding var item:String
    var body: some View {
        VStack(alignment:.leading, spacing: 8) {
         
            ZStack(alignment: .topLeading) {
             
                    RoundedRectangle(cornerRadius: 10)
//                        .frame(height:550)
                       
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                
                  
                
                TextEditor(text: $item)
                    .modifier(GlassEffectTextEditerModifier2())
  //                  .frame(minHeight:150, maxHeight: 400)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    
//                    .scrollContentBackground(.hidden)
//                    .font(Font.reg18)
//                    .accentColor(Color.customText)
//                    .foregroundColor(Color.customText)

                   
                
                if item.isEmpty {
                    Text("내용을 입력하세요...")
                        .foregroundColor(Color.gray.opacity(0.6))
                        .font(Font.reg12)
                        .padding(.top, 16)
                        .padding(.leading, 16)
                        .allowsHitTesting(false)
                }
            }
        }
        .foregroundColor(Color.clear)
    }
}
    
    
    

#Preview {
    SundayFormView()
}
