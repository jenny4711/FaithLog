//
//  api.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import Foundation
import SwiftData
// 파일 최상단 (DataService 밖)
struct EnVerse: Identifiable {
    let id = UUID()
    let number: Int
    let content: String
}



@Observable
class DataService {
    var bible: [BibleBK] = []
    var bibleEn: [String] = []          // 원본(받아온 문자열 배열)
       @MainActor var bibleEnParsed: [EnVerse] = []
    var selectedBible:[BibleBK] = []
    var selectedBibleEn:[EnVerse] = []
    var favoriteVerses:[BibleBK]  = []
    var bibleResp:String = ""
    var selected:Bool = false
    var like:Bool = false
    var errorMsg: String?
    var lang:Bool?
    var ch:Int?
    var enTitle:String?
    
    private let bibleURL = "https://bibleapi-fr2x.onrender.com/nb"
    
    
    
    @MainActor
        func normalizeBibleEn() {
            // 여러 조각을 하나로 이어서 절 기준으로 자르기
            let joined = bibleEn.joined(separator: " ")

            // 절 패턴: "1 "로 시작해서 다음 " 숫자 " 직전까지 (멀티라인 허용, non-greedy)
            let pattern = #"(?s)(\d{1,3})\s(.*?)(?=\s\d{1,3}\s|$)"#
            guard let regex = try? NSRegularExpression(pattern: pattern) else { return }

            var result: [EnVerse] = []
            let ns = joined as NSString
            let matches = regex.matches(in: joined, range: NSRange(location: 0, length: ns.length))

            for m in matches {
                let numStr = ns.substring(with: m.range(at: 1))
                let body   = ns.substring(with: m.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
                if let n = Int(numStr) {
                    result.append(EnVerse(number: n, content: body))
                }
            }

            // 혹시 순서가 어긋나면 정렬
            result.sort { $0.number < $1.number }
            self.bibleEnParsed = result
        }
    
    
    
    

    // MARK: - Favorites verse btn func
    
    
    
   


func saveFavVerse(_ verse:String){
        let selected = bible.filter {$0.verse == verse}
        
        for item in selected {
            if let idx = favoriteVerses.firstIndex(where:{$0.id == item.id}){
                favoriteVerses.remove(at:idx)
                self.like = false
            } else {
                favoriteVerses.append(item)
                self.like = true
            }
        }
    }





    //MARK: - Bible Verse
    
    func toggleBibleVerse(_ verse: String) {
        let selected = bible.filter { $0.verse == verse }
     
       
        
           for item in selected {
               if let index = selectedBible.firstIndex(where: { $0.id == item.id }) {
                   // 이미 있으면 제거
                   selectedBible.remove(at: index)
                   self.selected = false
               } else {
                   // 없으면 추가
                   selectedBible.append(item)
                   self.selected = true
               }
           }
        
        
        
        
        
        
        
       }
    
    
    @MainActor func toggleBibleVerseEn(_ verse: String) {
        let selected = bibleEnParsed.filter { $0.content == verse }
     
      
       
           for item in selected {
               if let index = selectedBibleEn.firstIndex(where: { $0.id == item.id }) {
                   // 이미 있으면 제거
                   selectedBibleEn.remove(at: index)
                   self.selected = false
               } else {
                   // 없으면 추가
                   selectedBibleEn.append(item)
                   self.selected = true
               }
           }
        
        
        
        
        
       print(selectedBibleEn)
        
       }
    
    
    
    func saveBibleVerse(_ verse: String) {
        let selected = bible.filter { $0.verse == verse }
        for item in selected {
            if !selectedBible.contains(where: { $0.id == item.id }) {
                selectedBible.append(item)
            }
        }
    }
    
    
    func getBibleResult(_ initial:String,_ title:String,chapter:String,enTitle:String,lang:Bool) async  {
        
        let lan = "English"
        let urlString = "https://bibleapi-fr2x.onrender.com/nb/\(initial)/findCh/\(title)/\(chapter)"
        let urlStringAi = "https://bibleapi-fr2x.onrender.com/nb/ai/getAiResp/\(enTitle)/\(chapter)/\(lan)"
        print("title:\(title)")
        if lang{
            await withTaskGroup(of:Void.self){
                group in
                group.addTask{
                   await self.performRequest(with:urlString)
                }
                
                
              
                
            }//:withTaskGroup
        }else{
            print("HERE!AI")
            await self.performRequestEn(with:urlStringAi)
            print("AFTER performRequestEn")
            
//            await withTaskGroup(of:Void.self){ group in
//                group.addTask{
//                    await self.performRequestEn(with:urlStringAi)
//                    print("group AI")
//                }
//            }
            
            do {
                
                let html = try await fetchNLTChapter(book: enTitle, chapter: Int(chapter)!)
                let verses = nltHTMLToVerseArray(html)   // ← 지금은 [String]
                bibleEn = verses
                ch = Int(chapter)
                self.enTitle = enTitle
                await MainActor.run { self.normalizeBibleEn() }   // ✅ 파싱
            } catch {
                print("error")
            }
            
        }
        
      
        
       


        
       
    }
    
    
    
    func performRequest(with urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let bibleList = parseJSON(data) {
                print("bibleList:--------\(bibleList)")
                await MainActor.run {
                    print("🔢 Before sorting: \(bibleList.map { $0.verse })")
                    let shortredBible = bibleList.sorted{ first, second in
                        let firstVerse = Int(first.verse) ?? 0
                        let secondVerse = Int(second.verse) ?? 0
                        return firstVerse < secondVerse
                    }
                    print("🔢 After sorting: \(shortredBible.map { $0.verse })")
                    self.bible = shortredBible
                }
            }
            
            
             // MARK: - RESP
            
            if let resp = parseJSONresp(data){
                await MainActor.run{
                    self.bibleResp = resp
                }
            }
            
        } catch {
            print("Network error: \(error)")
            await MainActor.run {
                self.errorMsg = error.localizedDescription
            }
        }
    }
    
    func parseJSON(_ data: Data) -> [BibleBK]? {
        let decoder = JSONDecoder()
        
        // 실제 JSON 응답 확인
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔍 Raw JSON response: \(jsonString)")
        }
        
        do {
            let decoded = try decoder.decode(BibleResponse.self, from: data)
            print("✅ Successfully decoded: \(decoded.resp) verses!!!!!!!!!!!!")
            return decoded.result
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Key not found: \(key) at \(context.codingPath)")
            return nil
        } catch {
            print("❌ JSON decode error: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
//    func performRequestEn(with urlString: String) async {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            print("dataResp:\(data)")
//            
//
//            
//             // MARK: - RESP
//            
//            if let resp = parseJSONresp(data){
//                await MainActor.run{
//                    self.bibleResp = resp
//                }
//            }
//            
//        } catch {
//            print("Network error: \(error)")
//            await MainActor.run {
//                self.errorMsg = error.localizedDescription
//            }
//        }
//    }
    
    
    
    private struct AiResponse: Decodable {
        let resp: String
    }

    @MainActor
    private func setError(_ message: String) {
        self.errorMsg = message
    }
    
    
    func performRequestEn(with urlString: String) async {
        guard let url = URL(string: urlString) else {
            self.errorMsg = "Invalid URL: \(urlString)"
            print("❌ Invalid URL:", urlString)
            return
        }
        print("🔗 AI URL:", url.absoluteString)

        var request = URLRequest(url: url)
        request.timeoutInterval = 20

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                self.errorMsg = "No HTTPURLResponse"
                print("❌ No HTTPURLResponse")
                return
            }
            print("📡 HTTP status:", http.statusCode)

            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            print("🧾 Raw body:", body)   // ✅ DEBUG 가드 없이 항상

            guard (200...299).contains(http.statusCode) else {
                self.errorMsg = "HTTP \(http.statusCode): \(body)"
                return
            }

            // 일단 원문 텍스트가 뭔지 바로 확인
            // (임시) 서버가 {"resp":"..."}가 아닐 수 있으니 원문을 그대로 표시해 봅니다.
            // 확인 후 아래 디코드로 되돌리면 됩니다.
            // self.bibleResp = body

            // 실제가 {"resp":"..."}면 이걸 사용
            struct AiResponse: Decodable { let resp: String }
            do {
                let decoded = try JSONDecoder().decode(AiResponse.self, from: data)
                self.bibleResp = decoded.resp
                self.errorMsg = nil
                print("✅ Decoded resp length:", decoded.resp.count)
            } catch {
                // 키 불일치 가능성—원문을 먼저 UI에서 확인해보자
                self.bibleResp = body
                self.errorMsg = "Decode fallback (check JSON shape)."
                print("⚠️ Decode failed, fell back to raw body. error:", error)
            }

        } catch {
            self.errorMsg = "Network/Decode error: \(error.localizedDescription)"
            print("❌ Network/Decode error:", error)
        }
    }

    
    
    
    

//    func performRequestEn(with urlString: String) async {
//        // 1) URL 검증
//        guard let url = URL(string: urlString) else {
//            await MainActor.run { setError("Invalid URL: \(urlString)") }
//            return
//        }
//
//        // 2) 요청 (타임아웃 구성 예시)
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 20 // 초
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            // 3) HTTP 상태 코드 체크
//            guard let http = response as? HTTPURLResponse else {
//                await MainActor.run { setError("No HTTPURLResponse") }
//                return
//            }
//            guard (200...299).contains(http.statusCode) else {
//                let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
//                await MainActor.run { setError("HTTP \(http.statusCode): \(body)") }
//                return
//            }
//
//            // 4) 로깅(디버그 시에만)
//            #if DEBUG
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("🔍 EN AI Raw JSON:", jsonString)
//            }
//            #endif
//
//            // 5) 디코드 (이 엔드포인트는 { resp: String } 가정)
//            let decoded = try JSONDecoder().decode(AiResponse.self, from: data)
//
//            // 6) UI 업데이트는 MainActor에서
//            await MainActor.run {
//                self.bibleResp = decoded.resp
//                self.errorMsg = nil
//            }
//
//        } catch {
//            await MainActor.run {
//                setError("Network/Decode error: \(error.localizedDescription)")
//            }
//        }
//    }
//-----------------
    
    
    
    
    
    func parseJSONresp(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        
        // 실제 JSON 응답 확인
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔍 Raw JSON response: \(jsonString)")
        }
        
        do {
            let decoded = try decoder.decode(BibleResponse.self, from: data)
           
            return decoded.resp
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Key not found: \(key) at \(context.codingPath)")
            return nil
        } catch {
            print("❌ JSON decode error: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            return nil
        }
    }
    
    
}
