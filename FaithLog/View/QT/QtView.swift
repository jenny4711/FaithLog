//
//  QtView.swift
//  FaithLog
//
//  Created by Ji y LEE on 7/30/25.
//

import SwiftUI
import SwiftData
struct QtView: View {
    @State var openForm:Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query(sort:\Qt.date,order:.reverse) private var Qts:[Qt]
    @State private var setAlarm:Bool = false
    @State private var isAnimated:Bool = false
    @State private var hr:Int = 9
    @State private var m:Int = 30
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.colorBackground
                    .ignoresSafeArea()
                    .font(Font.heavy25)
                    .foregroundColor(Color.colorText)
                
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .tint(Color.customText)
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    
                    VStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("logo")
                                .padding(.bottom, 20)
                        }
//                        ----------------------
                        HStack{
                            Text("Qt List")
                                .font(Font.heavy25)
                                .foregroundColor(Color.customText)
                            Button(action: {
                                openForm = true
                            }) {
                                
                                  
                                    
                                    Image(systemName: "plus")
                                    .font(Font.semi20)
                                        .foregroundColor(Color.customText)
                                        
                                
                            }
                            
                        }
                        //--------------------------------
                        
                    } //:VSTACK(logo and title)
                    
                    // MARK: - LIST
                    List {
                        ForEach(Qts) { item in
                            NavigationLink {
                                QtDetail(item: item)
                            } label: {
                                QtListCellView(item: item)
                            }
                            .swipeActions(edge:.trailing){
                                Button(action: {
                                    context.delete(item)
                                }) {
                                    Image(systemName: "trash")
                                }
                                .tint(Color.customBackground)
                            }
                            .listRowBackground(Color.customBackground)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }//:LOOP
                        

                    }//:LIST
                    

                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                    .listRowSpacing(12)
                    .background(Color.customBackground)
                    .padding(.horizontal, 24)
                    
                } //:VSTACK(LIST)
                
                // PlusBtnView를 ZStack으로 떠있게 배치
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
//                        PlusBtnView(openForm: $openForm)
                        HStack{
                            Spacer()
                            Button(action: {
                                setAlarm = true
                                

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
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            } //:ZSTACK
            .sheet(isPresented: $openForm) {
                QtFormView()
            }
            .sheet(isPresented:$setAlarm){
                TimePicker(hr: $hr, m: $m ,setAlerm:$setAlarm)
                    .presentationDetents([.fraction(0.8)])
            }
           
            

        }//:NAVIGATIONSTACK
        
        .navigationBarBackButtonHidden(true)
        
    }
}


struct TimePicker: View {
    @Binding var hr: Int
    @Binding var m: Int
    @Binding var setAlerm:Bool
    @State private var alarms: [ScheduledAlarm] = []
    @State private var groups: [TimeGroup] = []   // ★ 추가: 그룹 상태
    @State private var isLoading = false
  


    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    let days = 20
                   
                    NotificationManager.shared.scheduleDaily(hour: hr, minute: m)
                    reload()
                    setAlerm = false
                } label: {
                    Text("DONE").foregroundColor(.black)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 16)

            Text(String(format: "시간: %02d:%02d", hr, m))
                .font(Font.med20)
                .padding(.top, 16)

            HStack{
                            VStack{
                                Text("Hour")
                                    .font(Font.semi20)
                                HStack {
                                    Picker("Hr", selection: $hr) {
                                        ForEach(0..<24) { h in
                                            Text(String(format: "%02d", h)).tag(h)
                                                .font(.system(size: 30))
            
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
                                            .font(.system(size: 30))
            
                                    }
                                }
                                .pickerStyle(.wheel)
                                .colorScheme(.light)
                            }
            
            
                        }

            ScrollView {
                if groups.isEmpty && !isLoading {
                    Text("예약된 알림이 없습니다.").foregroundColor(.secondary)
                }
                ForEach(groups.filter{$0.hasRepeats}) { g in
                    HStack {
                        Text(String(format: "%02d:%02d", g.hour, g.minute))
                            .font(.system(size: 30))
                        Spacer()
                        if g.hasRepeats { Chip("반복") }
                        Text("\(g.count)일") // ← 동일 시각의 '미반복' 예약 개수(=일수)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button {
                            removeOne(from: g)  // ★ 가장 가까운 1개만 삭제
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width:30,height:30)
                        }
//                        .buttonStyle(.borderless))

                        Menu {
                            Button("이 시각의 예약 모두 삭제", role: .destructive) {
                                removeAll(in: g)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .foregroundColor(.red)
                                
                                .frame(width:30,height:30)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("알림 목록")
            .refreshable { reload() }
            .onAppear { reload() }
            .padding(.horizontal,24)
            .padding(.bottom,24)
        }
        .background(Color.customBackground)
    }

    // MARK: - 그룹 모델 & 로직

    struct TimeGroup: Identifiable {
        let id: String              // "HH:mm"
        let hour: Int
        let minute: Int
        var hasRepeats: Bool
        let count: Int              // 미반복(날짜 지정) 예약 개수
        let nonRepeatingIDs: [String]  // 날짜 지정 예약(가까운 순)
        let repeatingIDs: [String]     // repeats=true 예약
    }

    private func buildGroups(from list: [ScheduledAlarm]) -> [TimeGroup] {
        // HH:mm 키로 묶기
        var buckets: [String: [ScheduledAlarm]] = [:]
        for a in list {
            guard let h = a.hour, let m = a.minute else { continue }
            let key = String(format: "%02d:%02d", h, m)
            buckets[key, default: []].append(a)
        }

        // 그룹 생성
        let keys = buckets.keys.sorted()
        return keys.compactMap { key in
            guard let sample = buckets[key]?.first,
                  let h = sample.hour, let m = sample.minute else { return nil }

            // 가까운 날짜 순으로 정렬(미반복 우선)
            let sorted = buckets[key]!.sorted {
                let la = ($0.year ?? 9999, $0.month ?? 99, $0.day ?? 99)
                let lb = ($1.year ?? 9999, $1.month ?? 99, $1.day ?? 99)
                return la < lb
            }

            let nonRepeats = sorted.filter { !$0.repeats }
            let repeats    = sorted.filter {  $0.repeats }

            return TimeGroup(
                id: key,
                hour: h,
                minute: m,
                hasRepeats: !repeats.isEmpty,
                count: nonRepeats.count,
                nonRepeatingIDs: nonRepeats.map { $0.id },
                repeatingIDs: repeats.map { $0.id }
            )
        }
    }

    private func removeOne(from group: TimeGroup) {
        // 가장 가까운 '미반복' 1건 제거 (없으면 반복 1건 제거)
        if let id = group.nonRepeatingIDs.first {
            NotificationManager.shared.cancel(id: id)
        } else if let id = group.repeatingIDs.first {
            NotificationManager.shared.cancel(id: id)
        }
        // 약간의 지연 후 리로드(비동기 반영)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { reload() }
    }

    private func removeAll(in group: TimeGroup) {
        let ids = group.nonRepeatingIDs + group.repeatingIDs
        ids.forEach { NotificationManager.shared.cancel(id: $0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { reload() }
    }

    private func reload() {
        isLoading = true
        NotificationManager.shared.getPending { list in
            self.alarms = list
            self.groups = buildGroups(from: list)   // ★ 그룹 갱신
            self.isLoading = false
        }
    }
}

// 작은 칩
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






 // MARK: - ListCell

struct QtListCellView: View {
    var item:Qt?
    var body: some View {
        VStack{
            Text(item?.title ?? "")
                .font(Font.bold15)
               
            Text(item?.address ?? "")
                .font(Font.reg12)
        }
        .frame(maxWidth:.infinity)
        .padding()
        .background(Color.customText)
        .foregroundColor(Color.customBackground)
        .cornerRadius(15)
    }
}


 // MARK: - plus  button$$

struct PlusBtnView: View {
    @Binding var openForm:Bool
    var body: some View {
        Button(action: {
            openForm = true
        }) {
            ZStack{
                Circle()
                    .fill(Color.customText)
                    .frame(width:70)
                    .shadow(radius: 10)
                
                Image(systemName: "plus")
                    .font(Font.black30)
                    .foregroundColor(Color.customBackground)
                    
            }
        }
        
    }
}







#Preview {
    QtView()
}
