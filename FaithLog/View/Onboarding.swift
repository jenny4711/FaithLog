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
    @State var isKR : Bool = false
//    @State private var setAlarm:Bool = false
    @State private var isAnimated:Bool = false
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    
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
                           .padding(.top,50)
                        Spacer()
                        HStack{
                            NavigationLink{
                                QtView()
                            }label:{
                                SectionBtns(title:lang ? "묵상" : "QT")
                                
                            }//: NavigationLink(QTBTN)
                            
                            Button(action: {
                                showBibleForm = true
                            }) {
                                SectionBtns(title:lang ? "성경" : "BIBLE")
                            }//:BTN(BIBLE)
                            
                           
                            
                            
                        }//:HSTACK(qt,bible)
                       
                        
                        HStack{
                            NavigationLink{
                                SundayView()
                            }label:{
                                SectionBtns(title:lang ? "주일 예배" : "Sunday")
                                
                            }//: NavigationLink(Sunday)
                            
                            
                            NavigationLink{
                                Fav()
                                
                            }label:{
                                SectionBtns(title:lang ? "마음의구절" : "Fav Verse")
                            }
                            
                            
                            
                        }
                        
                        Spacer()
                        
                    }
                    .sheet(isPresented: $showBibleForm) {
                        BibleFormView()
                            .presentationDetents([.fraction(0.5)])
                        
                    }
                    
                   
                   
                    
                }
                HStack{
                    Spacer()
                    Button(action: {
                        isKR.toggle()
                        if isKR{
                            seleLang = "KR"
                        }else{
                            seleLang = "EN"
                        }
                        

                    }) {
                        ZStack{
                            
                            Circle()
                                .frame(width: 60,height:60)
                                .tint(Color.customText)
                            Text(lang ? "US" : "KR")
                                .font(Font.semi20)
                                .foregroundColor(Color.customBackground)
                            
                        }
                    }//:Button
                }
                .padding(.horizontal,16)
               
                

                
            }//:VSTACK
//            .sheet(isPresented:$setAlarm){
//                TimePicker(hr: $hr, m: $m ,setAlerm:$setAlarm)
//                    .presentationDetents([.fraction(0.8)])
//            }


            .background(
                Color.customBackground
            )
        }//:NAVIGATE STACK
        

    }
}

//struct TimePicker: View {
//    @Binding var hr: Int
//    @Binding var m: Int
//    @Binding var setAlerm:Bool
//    @State private var alarms: [ScheduledAlarm] = []
//    @State private var groups: [TimeGroup] = []   // ★ 추가: 그룹 상태
//    @State private var isLoading = false
//  
//
//
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                Button {
//                    let days = 20
//                   
//                    NotificationManager.shared.scheduleDaily(hour: hr, minute: m)
//                    reload()
//                    setAlerm = false
//                } label: {
//                    Text("DONE").foregroundColor(.black)
//                }
//            }
//            .padding(.trailing, 16)
//            .padding(.top, 16)
//
//            Text(String(format: "시간: %02d:%02d", hr, m))
//                .font(Font.med20)
//                .padding(.top, 16)
//
//            HStack{
//                            VStack{
//                                Text("Hour")
//                                    .font(Font.semi20)
//                                HStack {
//                                    Picker("Hr", selection: $hr) {
//                                        ForEach(0..<24) { h in
//                                            Text(String(format: "%02d", h)).tag(h)
//                                                .font(.system(size: 30))
//            
//                                        }
//                                    }
//                                    .pickerStyle(.wheel)
//                                    .colorScheme(.light)
//            
//                            }
//                            }
//            
//            
//            
//                            Divider().background(Color.customBackground)
//                            VStack{
//                                Text("Minutes")
//                                    .font(Font.semi20)
//                                Picker("Min", selection: $m) {
//                                    ForEach(0..<60) { mm in
//                                        Text(String(format: "%02d", mm)).tag(mm)
//                                            .font(.system(size: 30))
//            
//                                    }
//                                }
//                                .pickerStyle(.wheel)
//                                .colorScheme(.light)
//                            }
//            
//            
//                        }
//
//            ScrollView {
//                if groups.isEmpty && !isLoading {
//                    Text("예약된 알림이 없습니다.").foregroundColor(.secondary)
//                }
//                ForEach(groups.filter{$0.hasRepeats}) { g in
//                    HStack {
//                        Text(String(format: "%02d:%02d", g.hour, g.minute))
//                            .font(.system(size: 30))
//                        Spacer()
//                        if g.hasRepeats { Chip("반복") }
//                        Text("\(g.count)일") // ← 동일 시각의 '미반복' 예약 개수(=일수)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//
//                        Button {
//                            removeOne(from: g)  // ★ 가장 가까운 1개만 삭제
//                        } label: {
//                            Image(systemName: "trash")
//                                .resizable()
//                                .frame(width:30,height:30)
//                        }
////                        .buttonStyle(.borderless))
//
//                        Menu {
//                            Button("이 시각의 예약 모두 삭제", role: .destructive) {
//                                removeAll(in: g)
//                            }
//                        } label: {
//                            Image(systemName: "trash")
//                                .resizable()
//                                .foregroundColor(.red)
//                                
//                                .frame(width:30,height:30)
//                        }
//                        .buttonStyle(.borderless)
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.vertical, 6)
//                }
//            }
//            .navigationTitle("알림 목록")
//            .refreshable { reload() }
//            .onAppear { reload() }
//            .padding(.horizontal,24)
//            .padding(.bottom,24)
//        }
//        .background(Color.customBackground)
//    }
//
//    // MARK: - 그룹 모델 & 로직
//
//    struct TimeGroup: Identifiable {
//        let id: String              // "HH:mm"
//        let hour: Int
//        let minute: Int
//        var hasRepeats: Bool
//        let count: Int              // 미반복(날짜 지정) 예약 개수
//        let nonRepeatingIDs: [String]  // 날짜 지정 예약(가까운 순)
//        let repeatingIDs: [String]     // repeats=true 예약
//    }
//
//    private func buildGroups(from list: [ScheduledAlarm]) -> [TimeGroup] {
//        // HH:mm 키로 묶기
//        var buckets: [String: [ScheduledAlarm]] = [:]
//        for a in list {
//            guard let h = a.hour, let m = a.minute else { continue }
//            let key = String(format: "%02d:%02d", h, m)
//            buckets[key, default: []].append(a)
//        }
//
//        // 그룹 생성
//        let keys = buckets.keys.sorted()
//        return keys.compactMap { key in
//            guard let sample = buckets[key]?.first,
//                  let h = sample.hour, let m = sample.minute else { return nil }
//
//            // 가까운 날짜 순으로 정렬(미반복 우선)
//            let sorted = buckets[key]!.sorted {
//                let la = ($0.year ?? 9999, $0.month ?? 99, $0.day ?? 99)
//                let lb = ($1.year ?? 9999, $1.month ?? 99, $1.day ?? 99)
//                return la < lb
//            }
//
//            let nonRepeats = sorted.filter { !$0.repeats }
//            let repeats    = sorted.filter {  $0.repeats }
//
//            return TimeGroup(
//                id: key,
//                hour: h,
//                minute: m,
//                hasRepeats: !repeats.isEmpty,
//                count: nonRepeats.count,
//                nonRepeatingIDs: nonRepeats.map { $0.id },
//                repeatingIDs: repeats.map { $0.id }
//            )
//        }
//    }
//
//    private func removeOne(from group: TimeGroup) {
//        // 가장 가까운 '미반복' 1건 제거 (없으면 반복 1건 제거)
//        if let id = group.nonRepeatingIDs.first {
//            NotificationManager.shared.cancel(id: id)
//        } else if let id = group.repeatingIDs.first {
//            NotificationManager.shared.cancel(id: id)
//        }
//        // 약간의 지연 후 리로드(비동기 반영)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { reload() }
//    }
//
//    private func removeAll(in group: TimeGroup) {
//        let ids = group.nonRepeatingIDs + group.repeatingIDs
//        ids.forEach { NotificationManager.shared.cancel(id: $0) }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { reload() }
//    }
//
//    private func reload() {
//        isLoading = true
//        NotificationManager.shared.getPending { list in
//            self.alarms = list
//            self.groups = buildGroups(from: list)   // ★ 그룹 갱신
//            self.isLoading = false
//        }
//    }
//}
//
//// 작은 칩
//private struct Chip: View {
//    var text: String
//    init(_ text: String) { self.text = text }
//    var body: some View {
//        Text(text)
//            .font(.caption2)
//            .padding(.vertical, 3)
//            .padding(.horizontal, 6)
//            .background(Color(.systemGray5))
//            .clipShape(Capsule())
//    }
//}
//
//
//
//
//func addNotification(for hour:Int,min:Int?){
//    let center = UNUserNotificationCenter.current()
//    print(hour,min ?? 00)
//    let addRequest = {
//        let content = UNMutableNotificationContent()
//        content.title  = "묵상 시간"
//        content.subtitle = "묵상 하실 시간입니다."
//        content.sound = UNNotificationSound.default
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = hour
//        dateComponents.minute = min == 60 ? 0 : min
//        
//      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,repeats:false)
////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5,repeats:false)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
//        
//    }
//    center.getNotificationSettings {
//        settings in
//        if settings.authorizationStatus == .authorized{
//            addRequest()
//        }else{
//            center.requestAuthorization(options:[.alert,.badge,.sound]){
//                success,error in
//                if success{
//                    addRequest()
//                }else if let error {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//}


//
//struct TimePicker: View {
//    @Binding var hr: Int   // 0...23
//    @Binding var m: Int    // 0...59
//    @State private var alarms: [ScheduledAlarm] = []
//    @State private var isLoading = false
//    var body: some View {
//        VStack {
//            HStack{
//                Spacer()
//                Button(action: {
//                    NotificationManager.shared.scheduleDaily(hour: hr, minute: m)
//                    
//                }) {
//                    Text("DONE")
//                        .foregroundColor(Color.black)
//                }
//            }
//            .padding(.trailing,16)
//            .padding(.top,16)
//            Text(String(format: "시간: %02d:%02d", hr, m))
//                .font(Font.med20)
//                .padding(.top,16)
//          
//            HStack{
//                VStack{
//                    Text("Hour")
//                        .font(Font.semi20)
//                    HStack {
//                        Picker("Hr", selection: $hr) {
//                            ForEach(0..<24) { h in
//                                Text(String(format: "%02d", h)).tag(h)
//                                   
//                            }
//                        }
//                        .pickerStyle(.wheel)
//                        .colorScheme(.light)
//                    
//                }
//                }
//               
//           
//
//                Divider().background(Color.customBackground)
//                VStack{
//                    Text("Minutes")
//                        .font(Font.semi20)
//                    Picker("Min", selection: $m) {
//                        ForEach(0..<60) { mm in
//                            Text(String(format: "%02d", mm)).tag(mm)
//                                
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .colorScheme(.light)
//                }
//
//             
//            }
//            
//            
//           ScrollView{
//                if alarms.isEmpty && !isLoading {
//                               Text("예약된 알림이 없습니다.")
//                                   .foregroundColor(.secondary)
//                           }
//                
//                ForEach(alarms){
//                    alarm in
//                    HStack{
//                        HStack{
//                            Text(timeString(alarm))
//                                                      .font(.headline)
//                            Spacer()
//                            HStack{
//                                if alarm.repeats { Chip("매일") }
//                                                           Text(alarm.title.isEmpty ? "알림" : alarm.title)
//                                                               .foregroundColor(.secondary)
//                                                               .font(.caption)
//                            
//                            
//                            }//:HSTACK
//                            
//
//                    }
//                        
//                        Spacer()
//                        Button(role: .destructive) {
//                                             NotificationManager.shared.cancel(id: alarm.id)
//                                             reload()
//                                         } label: {
//                                             Image(systemName: "trash")
//                                         }
//                                         .buttonStyle(.borderless)
//                    
//                        
//                }
//                   
//                    .padding(.horizontal,60)
//                
//            }//:ScrollView
//            
//               
//            
//            
//            
//            
//            
//        }//:VSTACK
////        .background(Color.customText)
//        .navigationTitle("알림 목록")
//             .refreshable { reload() }
//             .onAppear { reload() }
//        
//
//        }//:VSTACK
//        .background(
//            Color.customBackground
//        )
//        
//
//}
//
//
//private func reload() {
//      isLoading = true
//      NotificationManager.shared.getPending { list in
//          self.alarms = list
//          self.isLoading = false
//      }
//  }
//
//  private func timeString(_ alarm: ScheduledAlarm) -> String {
//      if let h = alarm.hour, let m = alarm.minute {
//          return String(format: "%02d:%02d", h, m)
//      }
//      // 시간 정보가 없으면 식별자 표시(예외 케이스)
//      return alarm.id
//  }
//}
//
//// 작은 "칩" 스타일 레이블
//private struct Chip: View {
//  var text: String
//  init(_ text: String) { self.text = text }
//  var body: some View {
//      Text(text)
//          .font(.caption2)
//          .padding(.vertical, 3)
//          .padding(.horizontal, 6)
//          .background(Color(.systemGray5))
//          .clipShape(Capsule())
//  }
//}
//
//



#Preview {
    Onboarding()
}
