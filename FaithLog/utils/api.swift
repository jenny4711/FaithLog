//
//  api.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import Foundation
@Observable
class DataService {
    var bible: [BibleBK] = []
    var errorMsg: String?
    private let bibleURL = "https://bibleapi-fr2x.onrender.com/nb"
    
    
    
    
    func getBibleResult(_ initial:String,_ title:String,chapter:String) async  {
        
        
        print("initial:\(initial),title:\(title),chapter:\(chapter)")
        let urlString = "https://bibleapi-fr2x.onrender.com/nb/\(initial)/findCh/\(title)/\(chapter)"
        
        await withTaskGroup(of:Void.self){
            group in
            group.addTask{
               await self.performRequest(with:urlString)
            }
            
            
            
            
        }//:withTaskGroup
        
        
    
    }
    
    
    func performRequest(with urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let bibleList = parseJSON(data) {
                print("bibleList:--------\(bibleList)")
                await MainActor.run {
                    self.bible = bibleList
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
            print("✅ Successfully decoded: \(decoded.result.count) verses")
            return decoded.result
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type mismatch: expected \(type) at \(context.codingPath)")
            print("❌ Context: \(context.debugDescription)")
            print("❌ Full error: ")
            return nil
        } catch {
            print("❌ JSON decode error: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    
}
