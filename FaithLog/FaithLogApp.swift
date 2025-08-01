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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for:[Qt.self])
        }
    }
}
