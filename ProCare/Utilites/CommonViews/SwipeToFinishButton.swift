//
//  SwipeToFinishButton.swift
//  ProCare
//
//  Created by ahmed hussien on 23/05/2025.
//
import SwiftUI


import SwiftUI

//struct SwipeToFinishButton: View {
//    @State private var dragOffset: CGFloat = 0
//    @State private var isCompleted = false
//
//    let buttonHeight: CGFloat = 60
//    let dragThreshold: CGFloat = 0.7
//    let onComplete: () -> Void
//    
////    var isArabic: Bool {
////        Locale.current.language.languageCode?.identifier == "ar"
////       }
//
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                // Track background
//                RoundedRectangle(cornerRadius: buttonHeight / 2)
//                    .fill(Color.gray.opacity(0.2))
//
//                Text(isCompleted ? "Completed" : "Swipe to Finish")
//                    .foregroundColor(.gray)
//                    .bold()
//                    .opacity(dragOffset < geo.size.width * dragThreshold ? 1 : 0)
//
//                // Swipe circle
//                HStack {
//                    Circle()
//                        .fill(isCompleted ? Color.green : .appPrimary)
//                        .frame(width: buttonHeight - 10, height: buttonHeight - 10)
//                        .overlay(Image(systemName: isCompleted ? "checkmark" : "chevron.right")
//                            .foregroundColor(.white))
//                        .offset(x: dragOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    if !isCompleted {
//                                        dragOffset = max(0, min(value.translation.width, geo.size.width - buttonHeight))
//                                    }
//                                }
//                                .onEnded { _ in
//                                    if dragOffset > geo.size.width * dragThreshold {
//                                        withAnimation {
//                                            dragOffset = geo.size.width - buttonHeight
//                                            isCompleted = true
//                                            onComplete() // ✅ Trigger completion closure
//                                        }
//                                    } else {
//                                        withAnimation {
//                                            dragOffset = 0
//                                        }
//                                    }
//                                }
//                        )
//
//                    Spacer()
//                }
//                .frame(height: buttonHeight)
//            }
//        }
//        .frame(height: buttonHeight)
//        .padding(.horizontal)
//        //.environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//struct SwipeToFinishButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SwipeToFinishButton(onComplete: {} )
//    }
//}
