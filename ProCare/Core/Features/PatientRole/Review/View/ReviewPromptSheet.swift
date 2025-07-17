//
//  ReviewPromptSheet.swift
//  ProCare
//
//  Created by ahmed hussien on 15/07/2025.
//
import SwiftUI

struct ReviewPromptSheet: View {
    @EnvironmentObject var vm: ReviewVM
    @Binding var showSheet: Bool
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @FocusState private var isCommentFocused: Bool
    
    var order: Order
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                        // Header Section
                    VStack(spacing: 16) {
                        if let nursePicture = order.nursePicture {
                            AppImage(
                                urlString: nursePicture,
                                width: 80,
                                height: 80,
                                contentMode:  .fill,
                                shape: .circle
                            )
                        }
                        
                        if let nurseName = order.nurseName {
                            Text(nurseName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        if let price = order.totalPrice {
                            Text("total".localized() + ": \(price.asEGPCurrency())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                        // Rating Section
                    VStack(spacing: 12) {
                        Text("rate_experience")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    rating = star
                                        // Haptic feedback for better UX
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                    impactFeedback.impactOccurred()
                                }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(star <= rating ? .yellow : .gray.opacity(0.4))
                                        .scaleEffect(star <= rating ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.1), value: rating)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                            // Rating description
                        if rating > 0 {
                            Text(ratingDescription(for: rating))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .animation(.easeInOut(duration: 0.2), value: rating)
                        }
                    }
                    
                        // Comment Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("add_comment_optional")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("share_experience_placeholder", text: $comment, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(4...8)
                            .focused($isCommentFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                isCommentFocused = false
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("review_service".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("cancel".localized()) {
                        showSheet = false
                    }
                    .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("submit".localized()) {
                        Task {
                            await vm.AddReview(rating: rating, comment: comment) {
                                showSheet = false
                            }
                        }
                    }
                    .foregroundStyle(rating == 0 ? .secondary :Color.appPrimary)
                    .fontWeight(.semibold)
                    .disabled(rating == 0) // Disable if no rating selected
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("dont_show_again".localized()) {
                        Task {
                            await vm.cancelReviewByRequestId()
                        }
                        showSheet = false
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .onTapGesture {
                    // Dismiss keyboard when tapping outside
                isCommentFocused = false
            }
        }
        .presentationDetents([ .medium,.fraction(0.9) ,.large])
        .presentationDragIndicator(.visible)
    }
    
    private func ratingDescription(for rating: Int) -> String {
        switch rating {
        case 1:
            return "rating_poor".localized()
        case 2:
            return "rating_fair".localized()
        case 3:
            return "rating_good".localized()
        case 4:
            return "rating_very_good".localized()
        case 5:
            return "rating_excellent".localized()
        default:
            return ""
        }
    }
}
