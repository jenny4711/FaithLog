//
//  FavVerse.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/28/25.
//

import Foundation
import SwiftData
@Model
class FavVerse{
    @Attribute(.unique) var id: String
    var title: String
    var lang: String
    var chapter: String
    var verse: String
    var content: String
    var date:Date?
    
    init(title: String, lang: String, chapter: String, verse: String, content: String,date:Date) {
        self.id = UUID().uuidString
        self.title = title
        self.lang = lang
        self.chapter = chapter
        self.verse = verse
        self.content = content
        self.date = date
    }





     init() {
        self.id = UUID().uuidString
        self.title = ""
        self.lang = ""
        self.chapter = ""
        self.verse = ""
        self.content = ""
         self.date = .now
    }
    
}

