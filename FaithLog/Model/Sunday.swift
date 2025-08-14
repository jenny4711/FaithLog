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
    
    init(photo: Data? = nil, note: String = "") {
        self.photo = photo
        self.note = note
    }
    
}
