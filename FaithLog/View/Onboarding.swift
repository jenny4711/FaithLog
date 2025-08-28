//
//  Onboarding.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import UserNotifications









struct Onboarding: View {
    @State private var showBibleForm:Bool = false
    @State private var setAlarm:Bool = false
    @State private var hr:Int = 9
    @State private var m:Int = 30
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    Color(Color.customBackground)
                        .ignoresSafeArea()
                    
                    VStack{
                        Image("logo")
                            .resizable()
                            .frame(width:100,height:100)
                            .padding(.bottom,20)
                        HStack{
                            NavigationLink{
                                QtView()
                            }label:{
                                SectionBtns(title: "QT")
                                
                            }//: NavigationLink(QTBTN)
                            
                            Button(action: {
                                showBibleForm = true
                            }) {
                                SectionBtns(title: "Bible")
                            }//:BTN(BIBLE)
                            
                            
                            
                            
                        }//:HSTACK(qt,bible)
                        
                        HStack{
                            NavigationLink{
                                SundayView()
                            }label:{
                                SectionBtns(title: "SunDay")
                                
                            }//: NavigationLink(Sunday)
                        }
                        
                        
                        
                    }
                    .sheet(isPresented: $showBibleForm) {
                        BibleFormView()
                            .presentationDetents([.fraction(0.3)])
                        
                    }
                    
                   
                   
                    
                }
                HStack{
                    Spacer()
                    Button(action: {
                        setAlarm = true
                        
//                        addNotification(for: hr, min: m)
                    }) {
                        ZStack{
                            
                            Circle()
                                .frame(width: 60,height:60)
                                .tint(Color.customText)
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width:24,height:24)
                                .foregroundColor(Color.customBackground)
                            
                        }
                    }//:Button
                }
                .padding(.horizontal,16)
               
                

                
            }//:VSTACK
            .sheet(isPresented:$setAlarm){
                TimePicker(hr: $hr, m: $m)
                    .presentationDetents([.fraction(0.3)])
            }
            .onChange(of: hr) {_, newHr in
                NotificationManager.shared.scheduleDaily(hour: newHr, minute: m)
            }
            .onChange(of: m) {_, newMin in
                NotificationManager.shared.scheduleDaily(hour: hr, minute: newMin)
            }

            .background(
                Color.customBackground
            )
        }//:NAVIGATE STACK
        

    }
}





func addNotification(for hour:Int,min:Int?){
    let center = UNUserNotificationCenter.current()
    print(hour,min ?? 00)
    let addRequest = {
        let content = UNMutableNotificationContent()
        content.title  = "묵상 시간"
        content.subtitle = "묵상 하실 시간입니다."
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = min == 60 ? 0 : min
        
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,repeats:false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5,repeats:false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    center.getNotificationSettings {
        settings in
        if settings.authorizationStatus == .authorized{
            addRequest()
        }else{
            center.requestAuthorization(options:[.alert,.badge,.sound]){
                success,error in
                if success{
                    addRequest()
                }else if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}



struct TimePicker: View {
    @Binding var hr: Int   // 0...23
    @Binding var m: Int    // 0...59

    var body: some View {
        VStack {
            Text(String(format: "시간: %02d:%02d", hr, m))
                .font(Font.med20)
                .padding(.top,16)
          
            HStack{
                VStack{
                    Text("Hour")
                        .font(Font.semi20)
                    HStack {
                        Picker("Hr", selection: $hr) {
                            ForEach(0..<24) { h in
                                Text(String(format: "%02d", h)).tag(h)
                                   
                            }
                        }
                        .pickerStyle(.wheel)
                        .colorScheme(.light)
                    
                }
                }
               
           

                Divider().background(Color.customBackground)
                VStack{
                    Text("Minutes")
                        .font(Font.semi20)
                    Picker("Min", selection: $m) {
                        ForEach(0..<60) { mm in
                            Text(String(format: "%02d", mm)).tag(mm)
                                
                        }
                    }
                    .pickerStyle(.wheel)
                    .colorScheme(.light)
                }

             
            }
        }//:VSTACK
        .background(Color.customText)
        
        

    }
}



#Preview {
    Onboarding()
}
