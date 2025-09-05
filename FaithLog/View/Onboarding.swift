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
                                SectionBtns(title: "묵상")
                                
                            }//: NavigationLink(QTBTN)
                            
                            Button(action: {
                                showBibleForm = true
                            }) {
                                SectionBtns(title: "성경")
                            }//:BTN(BIBLE)
                            
                            
                            
                            
                        }//:HSTACK(qt,bible)
                        
                        HStack{
                            NavigationLink{
                                SundayView()
                            }label:{
                                SectionBtns(title: "주일 예배")
                                
                            }//: NavigationLink(Sunday)
                            
                            
                            NavigationLink{
                                Fav()
                                
                            }label:{
                                SectionBtns(title: "마음의구절")
                            }
                            
                            
                            
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
                    .presentationDetents([.fraction(0.5)])
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
    @State private var alarms: [ScheduledAlarm] = []
    @State private var isLoading = false
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    NotificationManager.shared.scheduleDaily(hour: hr, minute: m)
                    
                }) {
                    Text("DONE")
                }
            }
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
            
            
           ScrollView{
                if alarms.isEmpty && !isLoading {
                               Text("예약된 알림이 없습니다.")
                                   .foregroundColor(.secondary)
                           }
                
                ForEach(alarms){
                    alarm in
                    HStack{
                        HStack{
                            Text(timeString(alarm))
                                                      .font(.headline)
                            Spacer()
                            HStack{
                                if alarm.repeats { Chip("매일") }
                                                           Text(alarm.title.isEmpty ? "알림" : alarm.title)
                                                               .foregroundColor(.secondary)
                                                               .font(.caption)
                            
                            
                            }//:HSTACK
                            

                    }
                        
                        Spacer()
                        Button(role: .destructive) {
                                             NotificationManager.shared.cancel(id: alarm.id)
                                             reload()
                                         } label: {
                                             Image(systemName: "trash")
                                         }
                                         .buttonStyle(.borderless)
                    
                        
                }
                   
                    .padding(.horizontal,60)
                
            }//:ScrollView
            
               
            
            
            
            
            
        }//:VSTACK
//        .background(Color.customText)
        .navigationTitle("알림 목록")
             .refreshable { reload() }
             .onAppear { reload() }
        

        }//:VSTACK
        .background(
            Color.customBackground
        )
        

}


private func reload() {
      isLoading = true
      NotificationManager.shared.getPending { list in
          self.alarms = list
          self.isLoading = false
      }
  }

  private func timeString(_ alarm: ScheduledAlarm) -> String {
      if let h = alarm.hour, let m = alarm.minute {
          return String(format: "%02d:%02d", h, m)
      }
      // 시간 정보가 없으면 식별자 표시(예외 케이스)
      return alarm.id
  }
}

// 작은 "칩" 스타일 레이블
private struct Chip: View {
  var text: String
  init(_ text: String) { self.text = text }
  var body: some View {
      Text(text)
          .font(.caption2)
          .padding(.vertical, 3)
          .padding(.horizontal, 6)
          .background(Color(.systemGray5))
          .clipShape(Capsule())
  }
}





#Preview {
    Onboarding()
}
