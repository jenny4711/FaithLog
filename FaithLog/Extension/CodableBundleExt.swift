//
//  CodableBundleExt.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/4/25.
//


import Foundation
extension Bundle {
    func decode<T:Codable>(_ file:String) -> T {
        // TODO: Locate the JSON FiLE
        guard let url = self.url(forResource: file, withExtension: nil)else{
            fatalError("Failed to locate \(file) in bundle.")
        }
        // TODO: Create a property for the data
        guard let data = try? Data(contentsOf:url)else{
            fatalError("Failed to load \(file) from bundle")
        }
        // TODO: Create decoder
        let decoder = JSONDecoder()
        // TODO: Create property for the decoded data
        guard let decodedData = try? decoder.decode(T.self,from:data)else{
            fatalError("Failed to decode \(file) from bundle")
        }
        // TODO: Return the ready-to-use data
        return decodedData
    }
}
