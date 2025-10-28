//
//  FaithLogWidget.swift
//  FaithLogWidget
//
//  Created by Ji y LEE on 10/24/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, verse: "주는 나의 목자시니… (시 23:1)")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let last = SharedVerseStore.getLastShown() ?? SharedVerseStore.getNext().0 ?? "오늘도 말씀과 함께."
        return SimpleEntry(date: .now, verse: last)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        // 현재 보여줄 구절
        let (nextVerse, nextFireDate) = SharedVerseStore.getNext()
        let verse = SharedVerseStore.getLastShown() ?? nextVerse ?? "오늘도 말씀과 함께."
        let nowEntry = SimpleEntry(date: .now, verse: verse)

        // 다음 예약 시간이 있으면 그 이후에 갱신
        if let nextFireDate {
            return Timeline(entries: [nowEntry], policy: .after(nextFireDate))
        } else {
            return Timeline(entries: [nowEntry], policy: .atEnd)
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let verse: String
}

// MARK: - UI

struct FaithLogWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var family

    // 패밀리에 따른 폰트/라인 제한 등을 조절
    private var verseFont: Font {
        switch family {
        case .systemSmall:
            return .system(size: 10, weight: .regular)
        case .systemMedium:
            return .system(size: 16, weight: .regular)
        case .systemLarge:
            return .system(size: 18, weight: .regular)
        case .systemExtraLarge:
            return .system(size: 20, weight: .regular)
        case .accessoryCircular, .accessoryRectangular, .accessoryInline:
            return .system(size: 12, weight: .regular)
        @unknown default:
            return .system(size: 14, weight: .regular)
        }
    }

    private var verseLineLimit: Int? {
        switch family {
        case .systemSmall: return 3
        case .systemMedium: return 5
        case .systemLarge: return 7
        case .systemExtraLarge: return 9
        case .accessoryCircular, .accessoryRectangular, .accessoryInline: return 1
        @unknown default: return 4
        }
    }
    
    var body: some View {
        VStack {
            if case .accessoryInline = family {
                // 인라인은 텍스트만 간결히
                Text(entry.verse)
                    .font(verseFont)
                    .lineLimit(verseLineLimit)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color.colorText)
            } else {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.bottom, 10)
                Text(entry.verse)
                    .font(verseFont)
                    .lineLimit(verseLineLimit)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color.colorText)
            }
        }
      /*  .padding()*/ // 내부 여백만 유지, 배경은 컨테이너에서 설정
    }
}

struct FaithLogWidget: Widget {
    let kind: String = "FaithLogWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FaithLogWidgetEntryView(entry: entry)
                // 위젯 컨테이너 전체 배경 지정
                .containerBackground(Color.customBackground, for: .widget)
                // 필요 시 시스템 여백 제거해 가장자리까지 채우기 (신규 SDK)
                .modifier(WidgetContentMarginFix())
        }
    }
}

// Applies zero content margins on platforms that support the new API.
// On older OS versions, it leaves margins as-is to keep compilation working with newer SDKs.
private struct WidgetContentMarginFix: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18.0, macOS 15.0, watchOS 11.0, tvOS 18.0, *) {
            content.contentMargins(.all, 0)
        } else {
            content
        }
    }
}

#Preview(as: .systemSmall) {
    FaithLogWidget()
} timeline: {
    SimpleEntry(date: .now, verse: "주는 나의 목자시니… (시 23:1)")
    SimpleEntry(date: .now.addingTimeInterval(60 * 60), verse: "9하나님이 말씀하시기를 “하늘 아래에 있는 물은 한 곳으로 모이고, 뭍은 드러나거라” 하시니, 그대로 되었다.")
}

#Preview(as: .systemMedium) {
    FaithLogWidget()
} timeline: {
    SimpleEntry(date: .now, verse: "주는 나의 목자시니… (시 23:1)")
    SimpleEntry(date: .now.addingTimeInterval(60 * 60), verse: "9하나님이 말씀하시기를 “하늘 아래에 있는 물은 한 곳으로 모이고, 뭍은 드러나거라” 하시니, 그대로 되었다.")
}
