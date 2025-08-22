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
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var newSunday = Sunday()
    @State private var title:String = ""
    @State private var newNote:String = ""
    @StateObject private var askAi = AskAI()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    let item = Sunday()
                    item.title = title
                    item.note = newSunday.note
                    item.photo = newSunday.photo
                    context.insert(item)
                    dismiss()
                    
                }) {
                    Text("저장")
                        .padding(.trailing,16)
                        .foregroundColor(Color.customText)
                }
            }
            .padding(.top,24)
          
            VStack {
                
                // MARK: - 타이틀(title)
                
                
                VStack(alignment:.leading) {
                    Text("Title")
                        
                        .font(Font.bold15)
                        .foregroundColor(Color.colorText)
                    HStack {
                        TextField("",text:$title,axis:.vertical)
                            .frame(height:60)
                            .lineLimit(1...3)
                            .textFieldStyle(PlainTextFieldStyle())

                            .foregroundColor(Color.customBackground)
                    
                            .padding(.leading,16)
                            
                    }
                    .background(Color.customText)
                    .cornerRadius(10)
                   
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
                            .foregroundColor(Color.customText)
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Label("", systemImage: "photo.badge.plus")
                                .foregroundColor(Color.customBackground)
                                
                               
                        }
                        .listRowSeparator(.hidden)
                        
                    }//:ZSTACK
                    .padding(.bottom, 24) // 사진 선택기 아래 간격 추가
                }

                
                ScrollView{
                    Text(newSunday.note ?? "")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: 200) // ScrollView 높이 제한
                .padding(.horizontal, 24) // 좌우 패딩 추가
                
                Spacer() // 하단 여백 추가
                
            }
            .frame(maxWidth:.infinity)
            .background(Color.customBackground)
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

                           // ✅ async/await로 한 줄
                           let note = await askAi.recognizeTextAsync(from: data)
                           await MainActor.run {
                               newSunday.note = note
                               askAi.isLoading = false
                           }
                    
                    
                    
                    
                    
                    
//                    if let newValue = newValue {
//                        if let imageData = try? await newValue.loadTransferable(type: Data.self) {
//                            await MainActor.run {
//                                newSunday.photo = imageData
//                            }
//                            print("Image loaded successfully, size: \(imageData.count) bytes")
//                            
//                            // AI 서비스로 이미지 전송
//                            do {
//                                let note = try await askAi.getNote(imageData)
//                                await MainActor.run {
//                                    newSunday.note = note
//                                   
//                                }
//                                print("AI note generated: \(note)")
//                            } catch {
//                                print("Failed to get AI note: \(error)")
//                            }
//                        } else {
//                            print("Failed to load image data")
//                        }
//                    }
                }//:TASK
                

            }//:ONCHANGE
        }//:VSTACK
        .background(Color.customBackground)
        
        
      
    }
}

#Preview {
    SundayFormView()
}
