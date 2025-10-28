//
//  FavDetailView.swift
//  FaithLog
//
//  Created by Ji y LEE on 9/2/25.
//
//

import SwiftUI
import SwiftData
struct FavDetailView: View {
    var fav: FavVerse
    var content: String
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    // 문단 분리(쉼표/마침표/물음표/느낌표/세미콜론/콜론 기준)
    var parts: [String] {
        let delimiters = CharacterSet(charactersIn: ",.!?;:")
        return content
            .components(separatedBy: delimiters)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    // 단계 상태
    private enum QuizPhase { case showing, typing, done, empty }
    
    @State private var phase: QuizPhase = .showing
    @State private var currentIndex: Int = 0
    @State private var secondsLeft: Int = 20
    @State private var typing: String = ""
    @State private var wrongTry: Bool = false
    @State private var showUp:Bool = false
    @State private var showPhase:Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var target: String {
        guard parts.indices.contains(currentIndex) else { return "" }
        return parts[currentIndex]
    }
    
    var body: some View {
        VStack( spacing: 16) {
            HStack{
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                    
                        .tint(Color.customText)
                }
                
                Spacer()
                Button(action: {
                    withAnimation{
                        context.delete(fav)
                        do{
                            try context.save()
                            dismiss()
                        }catch{
                            print("삭제 실패: \(error)")
                        }
                        
                    }
               
                }) {
                    Image(systemName: "trash")
                }
            }//:HSTACK
            .padding(.horizontal,16)
                
            Text(fav.title ?? "")
                    .font(.title3.bold())
                    .padding(.leading,16)
                
                if parts.isEmpty {
                    Text("표시할 문단이 없습니다.")
                        .foregroundColor(.secondary)
                } else {
                    Text("문단 \(currentIndex + 1) / \(parts.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading,16)
                    
                    switch phase {
                    case .showing:
                        // 현재 문단만 10초 공개
                        VStack( spacing: 8) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.customText)
                                    .frame(height:150)
                                Text(target)
                                    .font(Font.reg18)
                                    .padding()
                                    .foregroundColor(Color.customBackground)
                                    .cornerRadius(12)
                            }
                            .frame(maxWidth:640,minHeight: 150)
                            .offset(y: showPhase ? 0 : -55)
                            .opacity(showPhase ? 1 : 0)
                            .padding()
                            
                            
                            HStack{
                                Text("남은 시간: \(secondsLeft)초")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button("외우기") {
                                    withAnimation {
                                        phase = .typing
                                        
                                        
                                    }
                                                }
                                .buttonStyle(.bordered)
                            }//:HSTACK(BTN)
                            .padding(.horizontal,16)
                            

                          
                        }
                        .onAppear{
                            withAnimation{
                                showUp = false
                                showPhase = true
                            }
                        }
                        
                    case .typing:
                        VStack(alignment: .leading, spacing: 10) {
                                                    // 필요하면 힌트(글자 수 등)
                                                    // Text("힌트: \(target.count)자").foregroundColor(.secondary)
                            HStack{
                                TextField("여기에 문단을 그대로 타이핑하세요", text: $typing,axis:.vertical)
                                   
//                                                        .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.never)
                                    .lineLimit(3)
                                    .autocorrectionDisabled(true)
//
                                   .frame(height:150)
                                    .padding(.horizontal,16)
                            }
                            
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(wrongTry ? Color.red : Color.clear, lineWidth: 1)
                                    .fill(Color.white)
                            )
                            .animation(.easeInOut(duration: 1),value:showUp)
                            .offset(x: showUp ? 0 : 250)
                            
                                                    
                                                    HStack {
                                                        Button("확인") { checkAnswer() }
                                                            .buttonStyle(.bordered)
                                                            .background(Color.customText)
                                                            .cornerRadius(10)
                                                            .foregroundColor(Color.customBackground)
                                                           
                                                        Button("초기화") {
                                                            typing = ""
                                                            wrongTry = false
                                                            
                                                        }
                                                        .buttonStyle(.bordered)
                                                        
                                                        Button("다시 보기(20초)") {
                                                                secondsLeft = 20
                                                            withAnimation {
                                                                phase = .showing
                                                              
                                                               
                                                            }
                                                                        }
                                                            .buttonStyle(.bordered)
                                                    }//:HSTACk(btns)
                                                    .padding(.horizontal,16)
                                                    .padding(.top,16)
                                                    

                                                    
                                                }//:VSTACK
                                                .padding(.horizontal,16)
                                                .onAppear{
                                                    withAnimation{
                                                        showUp = true
                                                        showPhase = false
                                                    }
                                                }
                                                
                                                
                        
                    case .done:
                        FavDoneView(fav: fav, parts: parts)
                        
                    case .empty:
                        EmptyView()
                    }
                }
                
                Spacer()
            }//:VSTACK
            .background(Color.customBackground)
            .foregroundColor(Color.customText)
            .navigationBarBackButtonHidden(true)
            //        .padding()
            .onAppear {
                if parts.isEmpty { phase = .empty }
            }
            .onReceive(timer) { _ in
                guard phase == .showing else { return }
                if secondsLeft > 0 {
                    secondsLeft -= 1
                } else {
                    // 공개 시간 끝 → 타이핑 단계로
                    withAnimation {
                        phase = .typing
                        //                    typing = ""
                        wrongTry = false
                    }
                }
            }
            
        }
        
        
        
        // MARK: - FUNCTION
        
        private func checkAnswer() {
            let typed = normalize(typing)
            let answer = normalize(target)
            print("typed:\(typed)")
            print("answer:\(answer)")
            if typed == answer {
                // 정답 → 다음 문단 10초 공개
                wrongTry = false
                typing = ""
                if currentIndex + 1 < parts.count {
                    currentIndex += 1
                    secondsLeft = 20
                    withAnimation { phase = .showing }
                } else {
                    withAnimation { phase = .done }
                }
            } else {
                wrongTry = true
            }
        }
        
        // 비교 관대함(공백 정리 + 대소문자 무시). 필요하면 문장부호 제거도 추가 가능.
        private func normalize(_ s: String) -> String {
            s.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            // 문장부호도 무시하려면 아래 한 줄 추가:
                .replacingOccurrences(of: "[\\p{P}]", with: "", options: .regularExpression)
        }
    }
    




