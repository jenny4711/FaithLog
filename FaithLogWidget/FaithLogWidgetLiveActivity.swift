//
//  FaithLogWidgetLiveActivity.swift
//  FaithLogWidget
//
//  Created by Ji y LEE on 10/24/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FaithLogWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FaithLogWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FaithLogWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FaithLogWidgetAttributes {
    fileprivate static var preview: FaithLogWidgetAttributes {
        FaithLogWidgetAttributes(name: "World")
    }
}

extension FaithLogWidgetAttributes.ContentState {
    fileprivate static var smiley: FaithLogWidgetAttributes.ContentState {
        FaithLogWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FaithLogWidgetAttributes.ContentState {
         FaithLogWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FaithLogWidgetAttributes.preview) {
   FaithLogWidgetLiveActivity()
} contentStates: {
    FaithLogWidgetAttributes.ContentState.smiley
    FaithLogWidgetAttributes.ContentState.starEyes
}
