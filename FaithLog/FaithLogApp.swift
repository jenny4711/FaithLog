//
//  FaithLogApp.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import SwiftData
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
      if !granted { print("알림 권한 거부됨") }
    }
    return true
  }

 
}





@main
struct FaithLogApp: App {
    @State private var dataService = DataService()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init(){
        NotificationManager.shared.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for:[Qt.self,Sunday.self])
                .environment(dataService)
        }
    }
}
