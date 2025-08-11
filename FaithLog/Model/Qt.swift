//
//  Qt.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import Foundation
import SwiftData
@Model
class Qt{
    @Attribute(.unique) var id:String
    var title:String = ""
    var appl:String = ""
    var medit:String = ""
    var pray:String = ""
    var address:String = ""
    var date:Date = Date()
    @Relationship(deleteRule: .cascade) var content: [BibleBK] = []
    
    init(){
        id = UUID().uuidString
    }
}
