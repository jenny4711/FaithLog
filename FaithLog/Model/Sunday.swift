//
//  Sunday.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/14/25.
//

import Foundation
import SwiftData
@Model
class Sunday{
    @Attribute(.externalStorage) var photo:Data?
    var note:String = ""
    var date:Date = Date()
    var title:String = ""
    init(photo: Data? = nil, note: String = "",title:String = "") {
        self.photo = photo
        self.note = note
        self.title = title
    }
    
}
