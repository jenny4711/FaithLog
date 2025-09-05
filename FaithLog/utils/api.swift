//
//  api.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//

import Foundation
import SwiftData

@Observable
class DataService {
    var bible: [BibleBK] = []
    var selectedBible:[BibleBK] = []
    var favoriteVerses:[BibleBK]  = []
    var bibleResp:String = ""
    var selected:Bool = false
    var like:Bool = false
    var errorMsg: String?
    
    
    private let bibleURL = "https://bibleapi-fr2x.onrender.com/nb"

    // MARK: - Favorites verse btn func
    // func saveFavVerse(_ verse:String){
    //     let selected = bible.filter {$0.verse == verse}
        
    //     for item in selected {
    //         if let idx = favoriteVerses.firstIndex(where:{$0.id == item.id}){
    //             favoriteVerses.remove(at:idx)
               

    //             self.like = false
    //         }else{
    //             favoriteVerses.append(item)
    //             self.like = true
    //         }
    //     }
    // }


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
    
    func saveBibleVerse(_ verse: String) {
        let selected = bible.filter { $0.verse == verse }
        for item in selected {
            if !selectedBible.contains(where: { $0.id == item.id }) {
                selectedBible.append(item)
            }
        }
    }
    
    
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
