//
//  FaithLogWidgetBundle.swift
//  FaithLogWidget
//
//  Created by Ji y LEE on 10/24/25.
//

import WidgetKit
import SwiftUI

@main
struct FaithLogWidgetBundle: WidgetBundle {
    var body: some Widget {
        FaithLogWidget()
        FaithLogWidgetControl()
        FaithLogWidgetLiveActivity()
    }
}
