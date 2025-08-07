//
//  FaithLogApp.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import SwiftData
@main
struct FaithLogApp: App {
    @State private var dataService = DataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for:[Qt.self])
                .environment(dataService)
        }
    }
}
