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
    @StateObject private var askAi = AskAI()
    
    var body: some View {
        VStack{
          
            Form {
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
                    Text("Add your note")
                        .foregroundColor(.secondary)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top)
                }
                
                //MARK: -photo picker
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Label("Select a Photo", systemImage: "photo.badge.plus")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .listRowSeparator(.hidden)
                
                ScrollView{
                    Text(newSunday.note ?? "")
                }
                
                
                
            }
           
            .onChange(of: photosPickerItem) { _, newValue in
                Task {
                    if let newValue = newValue {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self) {
                            await MainActor.run {
                                newSunday.photo = imageData
                            }
                            print("Image loaded successfully, size: \(imageData.count) bytes")
                            
                            // AI 서비스로 이미지 전송
                            do {
                                let note = try await askAi.getNote(imageData)
                                await MainActor.run {
                                    newSunday.note = note
                                }
                                print("AI note generated: \(note)")
                            } catch {
                                print("Failed to get AI note: \(error)")
                            }
                        } else {
                            print("Failed to load image data")
                        }
                    }
                }
            }//:ONCHANGE
        }//:VSTACK
        

        
      
    }
}

#Preview {
    SundayFormView()
}
