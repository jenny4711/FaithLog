//
//  AskAI.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/11/25.
//

////
//  askAI.swift
//  CookTok
//
//  Created by Ji y LEE on 7/21/25.
//

import Combine
import FirebaseVertexAI
import FirebaseAI

class AskAI: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var geminiResponse: String?
    @Published var showAISummery: Bool = false
    
    private let model: GenerativeModel = VertexAI.vertexAI().generativeModel(modelName: "gemini-2.0-flash")
    
    func newRecipe(title:String,chapter:String,lang:String) async {
        await getRecipe(title,chapter,lang)
    }
}

extension AskAI {
    func getNote(_ image: Data) async -> String {
        print("image: \(image)")
        
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let prompt = """
            이 이미지를 분석하여 정리해서 보기 편하게 노트를 작성해주세요.
            
            """
            
            // 이미지 데이터를 InlineDataPart로 변환하여 전달
            let imagePart = InlineDataPart(data: image, mimeType: "image/jpeg")
            let response = try await model.generateContent(prompt, imagePart)
            let responseText = response.text ?? "이미지 분석에 실패했습니다."
            
            await MainActor.run {
                self.isLoading = false
            }
            
            return responseText
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            print("이미지 분석 오류: \(error)")
            return "이미지 분석 중 오류가 발생했습니다."
        }
    }
    
    func getRecipe(_ title:String, _ chapter:String, _ lang:String) async {
    


        
        await MainActor.run {
            self.isLoading = true
            self.geminiResponse = "Gemini가 생각 중입니다..."
        }

        do {
            // 재료 이름들을 문자열로 변환
         
            
            let promptKR = """
            passage: \(title)  \(chapter)장 
            Output in Korean
            avoid word:중학생,청소년,middle school students
                       
                       위의 성경구절을 중학생이 이해할수있도록 줄거리를 설명해주시고,
                       서론필요없이, 내용요약 만 알려주세요. 
            """
            
            let prompt = """
            Give a plain-English summary for middle school students.
            No introduction—summary and story only, 3–10 sentences.
            
            """
          
           print("lang-AI-\(lang)")
            
            var response = try await model.generateContent(prompt)
            if lang == "KOR"{
                response = try await model.generateContent(promptKR)
            }else{
                response = try await model.generateContent(prompt)
            }
            let responseText = response.text
          
            await MainActor.run {
                if let text = responseText {
                    self.geminiResponse = text
                    print(text)
                  // self.showAISummery = true  // 응답을 받으면 시트 표시
                } else {
                    self.geminiResponse = "응답이 없습니다."
                }
            }
        } catch {
            await MainActor.run {
                self.geminiResponse = "오류 발생"
                print(error.localizedDescription)
            }
            print("Gemini API 호출 오류: \(error)")
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
    
    
    
}
