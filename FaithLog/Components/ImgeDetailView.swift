//
//  ImgeDetailView.swift
//  FaithLog
//
//  Created by Ji y LEE on 10/1/25.
//



import SwiftUI

struct ImgeDetailView: View {
    let item: Sunday?
    @State private var imageOffset: CGSize = .zero
    @State private var imageScale: CGFloat = 1
    @State private var isAnimating = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                
                }

                if let data = item?.photo, let uiImg = UIImage(data: data) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .scaledToFit() // ← 비율 유지, 잘림 없음
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .opacity(isAnimating ? 1 : 0)
                        .offset(imageOffset)
                        .scaleEffect(imageScale)
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2) {
                            withAnimation(.spring()) {
                                imageScale = (imageScale == 1) ? 2 : 1
                                if imageScale == 1 { imageOffset = .zero }
                            }
                        }
                        .gesture(DragGesture().onChanged { v in
                            if imageScale > 1 { imageOffset = v.translation }
                        }.onEnded { _ in
                            if imageScale <= 1 { imageOffset = .zero }
                        })
                        .gesture(MagnificationGesture().onChanged { value in
                            imageScale = min(max(value, 1), 3)
                        }.onEnded { _ in
                            if imageScale <= 1 { imageOffset = .zero }
                        })
                        .onAppear {
                            withAnimation(.linear(duration: 0.25)) { isAnimating = true }
                        }
                }
            }
        }
    }


