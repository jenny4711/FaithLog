//
//  Fav.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/30/25.
//

import SwiftUI
import SwiftData

struct Fav: View {
    @Query private var favs:[FavVerse]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var setAlert:Bool = false
    @State private var hr = 9
    @State private var m  = 30
    @AppStorage("seleLang") private var seleLang:String = "KR"

    var lang: Bool {
        seleLang == "KR"
    }
    let colums = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    
    // MARK: - func
    func randomVerse() -> FavVerse{
        let random = favs.randomElement() ?? favs[0]
        
        
        return random
    }
    
    // 하루당 1개만 사용(다음 날로 넘어갈수록 다음 구절), days 개 생성
    static func makeDailyVerseItems(from favs: [FavVerse], days: Int) -> [VerseItem] {
        guard !favs.isEmpty, days > 0 else { return [] }
        let key = "verseDayRotationIndex" // 일 단위 회전 인덱스
        var idx = UserDefaults.standard.integer(forKey: key) // 기본 0
        
        var out: [VerseItem] = []
        out.reserveCapacity(days)
        for _ in 0..<days {
            let v = favs[idx % favs.count]
            out.append(VerseItem(title: "\(v.title) \(v.chapter)장", body: v.content))
            idx += 1
        }
        UserDefaults.standard.set(idx % max(1, favs.count), forKey: key)
        return out
    }
    
    
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.customBackground
                    .ignoresSafeArea()
                    .font(Font.heavy25)
                    .foregroundColor(Color.colorText)
                VStack{
                    // MARK: - LEFT BTN
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                            
                                .tint(Color.customText)
                        }
                        Spacer()
                        
                        
                        
                        
                    }//:HSTACK(BTN)
                    
                    
                    .padding(.leading,16)
                  
                    // MARK: - TITLE
                    VStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image("logo")
                                .padding(.bottom, 20)
                        }
                        Text("Favorite List")
                            .font(Font.heavy25)
                            .foregroundColor(Color.customText)
                        if lang{
                            Text("힘들 때 떠오르는 한 구절이 큰 힘이 됩니다. 좋아하는 구절을 즐겨찾기에 담고, 하루에 한 번 마음에 새겨보세요.")
                                .modifier(IntroTextModifier())
                        }else{
                            Text("A single verse can lift you when times are hard. Save your favorites and let one verse settle into your heart each day.")
                                .modifier(IntroTextModifier())
                        }
                        
                       
                        
                    }//:VSTACK(logo and title)
                    
                    // MARK: - LIST
                    ScrollView{
                        LazyVGrid(columns:colums,spacing:5){
                            ForEach(favs,id:\.self){
                                item in
                                NavigationLink{
                                    FavDetailView(fav: item, content: item.content)
                                }label:{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.customText)
                                        .frame(height:180)
                                        .overlay {
                                            
                                            
                                            VStack{
                                                Text("\(item.title)-\(item.chapter)장")
                                                    .foregroundColor(Color.customBackground)
                                                Text("\(item.content)")
                                                    .lineLimit(3)
                                                    .truncationMode(.tail)
                                                    .foregroundColor(item.content.containsSpecialCharacter ? Color.customBackground :Color.red)
                                                    .padding()
                                            }
                                            
                                        }
                                        .padding(.vertical,16)
                                }
                                
                                
                                
                            }//:loop
                            
                        }
                        
                        .padding(.horizontal,24)
                        
                    }//:SCROLLview
                    
                    
                    .scrollIndicators(.hidden)
                    
                }//:VSTACK
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            setAlert = true
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
                        }
                        .modifier(GlassEffectBtnModifier())
                    }//:HSTACK(BTN)
                    
                    
                }//:VSTACK(BTN)
                
                
                
                
            }//:ZSTACK
            .sheet(isPresented:$setAlert){
                TimePicker(
                    hr: $hr,
                    m: $m,
                    setAlert: $setAlert,
                    pickRandomVerse: { self.randomVerse() }, favs: favs   // ← 전달
                )
                .presentationDetents([.fraction(0.8)])
                
            }
            
            
            .padding(.horizontal,24)
            
            
        }
        .background(Color.customBackground)
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    
    
    // MARK: - alertPicker
    
    struct TimePicker: View {
        @Binding var hr: Int
        @Binding var m: Int
        @State private var alarms: [ScheduledAlarm] = []
        @State private var groups: [TimeGroup] = []   // ★ 추가: 그룹 상태
        @State private var isLoading = false
        @Binding var setAlert:Bool
        @AppStorage("seleLang") private var seleLang:String = "KR"

        var lang: Bool {
            seleLang == "KR"
        }
        let pickRandomVerse: () -> FavVerse
        let favs: [FavVerse]

        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    
                   
                    Button {
                        let days = 20
                        let items = makeDailyVerseItems(from: favs, days: days)
                        NotificationManager.shared.scheduleDaily3x6h_RotatingDays(
                            startHour: hr, startMinute: m, days: days, dayItems: items
                        )
                        reload()
                        setAlert = false
                    } label: {
                        Text(lang ? "저장" :"DONE")
                            .font(Font.med20)
                            .foregroundColor(Color.customText)
                            .padding(.trailing,16)
                        
                    }
                   

                    
                }//:HSTACK
                

                .padding(.trailing, 16)
                .padding(.top, 16)

                HStack{
                    Text(lang ?"선택된 시간:" : "Selected Time")
                        .font(Font.reg18)
                        .foregroundColor(Color.customText)
                        .padding(.top, 16)
                    Text(String(format: "%02d:%02d", hr, m))
                        .font(Font.black36)
                        .foregroundColor(Color.customText)
                        .padding(.top, 16)
                }
                
               // MARK: - Intro
                if lang {
                    Text("마음이 흔들릴 때, 미리 설정해 둔 말씀이 먼저 찾아옵니다. 좋아하는 구절로 알람을 맞춰 두면, 필요한 순간에 따뜻한 위로를 전해드려요..")
                        .modifier(IntroTextModifier())
                }else{
                    Text("When your heart feels unsteady, the verse you scheduled will come to you first. Set an alarm with a favorite verse so encouragement arrives right when you need it.")
                        .modifier(IntroTextModifier())
                }
               

                HStack{
                                VStack{
                                    Text("Hour")
                                        .font(Font.semi20)
                                        .foregroundColor(Color.customText)
                                    HStack {
                                        Picker("Hr", selection: $hr) {
                                            ForEach(0..<24) { h in
                                                Text(String(format: "%02d", h)).tag(h)
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.customText)

                
                                            }
                                        }
                                        .pickerStyle(.wheel)
//                                        .colorScheme(.light)
                                                                                            
                
                                }
                                }
                
                
                
                                Divider().background(Color.customBackground)
                                VStack{
                                    Text("Minutes")
                                        .font(Font.semi20)
                                        .foregroundColor(Color.customText)
                                    Picker("Min", selection: $m) {
                                        ForEach(0..<60) { mm in
                                            Text(String(format: "%02d", mm)).tag(mm)
                                                .font(.system(size: 30))
                                                .foregroundColor(Color.customText)
                
                                        }
                                    }
                                    .pickerStyle(.wheel)
//                                    .colorScheme(.light)
                                }
                
                
                            }

                ScrollView {
                    if groups.isEmpty && !isLoading {
                        Text(lang ? "예약된 알림이 없습니다." :"No notifications scheduled.").foregroundColor(.secondary)
                    }
                    ForEach(groups.filter{!$0.hasRepeats}) { g in
                        HStack {
                            Text(String(format: "%02d:%02d", g.hour, g.minute))
                                .font(.system(size: 30))
                                .foregroundColor(Color.customText)
                            Spacer()
                            if g.hasRepeats { Chip(lang ? "반복" : "Repeat") }
                            Text(lang ? "\(g.count)일": "\(g.count)Days") // ← 동일 시각의 '미반복' 예약 개수(=일수)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button {
                                removeOne(from: g)  // ★ 가장 가까운 1개만 삭제
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width:30,height:30)
                                
                            }
//                            .buttonStyle(.borderless))

                            Menu {
                                Button(lang ? "이 시각의 예약 모두 삭제" : "Remove all reminders for this time", role: .destructive) {
                                    print("All remove")
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
                        .padding(.vertical, 12)
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
            let hasRepeats: Bool
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


    
    
    
    
}
    







#Preview {
    Fav()
}
