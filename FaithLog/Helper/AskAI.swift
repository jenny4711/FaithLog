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

import Vision
import PhotosUI

class AskAI: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var geminiResponse: String?
    @Published var showAISummery: Bool = false
    
    
 


    func recognizeText(from uiImage: UIImage, completion: @escaping (String) -> Void) {
        let request = VNRecognizeTextRequest { req, _ in
            let texts = (req.results as? [VNRecognizedTextObservation])?
                .compactMap { $0.topCandidates(1).first?.string } ?? []
            completion(texts.joined(separator: "\n"))
        }
        request.recognitionLanguages = ["ko-KR","en-US"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: uiImage.cgImage!, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

 
}

extension AskAI {
    
    func recognizeTextAsync(from image: UIImage) async -> String {
           await withCheckedContinuation { cont in
               recognizeText(from: image) { text in
                   cont.resume(returning: text)
               }
           }
       }

       func recognizeTextAsync(from data: Data) async -> String {
           guard let image = UIImage(data: data) else { return "" }
           return await recognizeTextAsync(from: image)
       }
    
    

    
    
}
