//
//  BibleApi.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import Foundation
import CoreLocation
import Combine

class BibleApi:ObservableObject{
    @Published var bible:[Bible]?
    @Published var errorMsg:String?
    @Published var isLoading: Bool = false
    private let bibleURL = "https://bibleapi-fr2x.onrender.com/nb"
    
    
    init(bible: [Bible]? = nil, errorMsg: String? = nil, isLoading: Bool) {
        self.bible = bible
        self.errorMsg = errorMsg
        self.isLoading = isLoading
    }
    
    
    
    func finInitCode(_ title:String) -> String {
        
        switch title {
        case "시편":
            return "psa"
        case "느헤미야기":
              return "neh"
          case "요한복음":
              return "joh"
            
        default:
            return "unKnown"
        }
    }
    
    
    
    func  fetchBible(
        title: String? = "시편",
        bible: String? = "psa",
        fromCh: Int? = 23,
        fromVs: Int? = 1,
        toCh: Int? = 23,
        toVs: Int? = 3
    ) async {
        guard let tit = title, let fCh = fromCh, let fVs = fromVs, let tCh = toCh, let tVs = toVs else {
            self.errorMsg = "Invalid location data"
            return
        }

        let urlString = "\(bibleURL)/\(finInitCode(tit))/findCh/\(tit)/\(fCh)/\(fVs)/\(tCh)/\(tVs)"
     

        // --- 여기서부터 병렬 처리 시작! ---
        await withTaskGroup(of: Void.self) { group in
           
            group.addTask {
                self.performRequest(with: urlString) // performRequest는 이미 내부적으로 비동기 처리하므로 await 필요 없음
            }
        }
     
    }
    
    private func performRequest(with urlString: String) {
            guard let url = URL(string: urlString) else {
                self.errorMsg = "Invalid URL"
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async { [self] in
                    if let error = error {
                        self.errorMsg = error.localizedDescription
                        return
                    }

                    if let safeData = data {
//                        print("📦 RAW JSON:\n", String(data: safeData, encoding: .utf8) ?? "Invalid Data")
                        if let bibleList = self.parseJSON(safeData) {
                            print("BibleList- \(bibleList)")
                            self.bible = bibleList
                        }

                    }
                }
            }.resume()
        }


    
    func parseJSON(_ data: Data) -> [Bible]? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(BibleResponse.self, from: data)
            return decoded.result
        } catch {
            print("❌ JSON decode error: \(error)")
            return nil
        }
    }


    
    
    
    
}

