//
//  SwipeToDismiss.swift
//  FaithLog
//
//  Created by Ji y LEE on 8/9/25.
//

import SwiftUI


struct SwipeToDismiss: ViewModifier {
    @Binding var isPresented: Bool
    @State var verticalDragAmount = 0.0
    @State var opacityAmount = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(y: verticalDragAmount)
            .opacity(opacityAmount)
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        withAnimation {
                            verticalDragAmount = drag.translation.height
                            if drag.translation.height < 100 {
                                // make it more transparent the farther down it goes
                                opacityAmount = (100 - verticalDragAmount) / 100
                            } else {
                                opacityAmount = 0
                            }
                        }
                    }
                    .onEnded { drag in
                        withAnimation {
                            if drag.translation.height > 100 {
                                isPresented = false
                                opacityAmount = 0
                            } else {
                                verticalDragAmount = 0
                                opacityAmount = 1
                            }
                        }
                    }
            )
    }
}

extension View {
    func swipeToDismiss(_ isPresented: Binding<Bool>) -> some View {
        modifier(SwipeToDismiss(isPresented: isPresented))
    }
}
