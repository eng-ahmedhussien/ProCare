//
//  NuresDetails.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import SwiftUI

struct NurseDetailsScreen: View {
    @EnvironmentObject var vm: HomeVM
    var servicesIds: [ServiceItem] = []
    var nurse: Nurse?
    var total: Int = 0
    @EnvironmentObject var appRouter : AppRouter
    @State private var showAllReviews = false
    let width = UIScreen.main.bounds.width * 0.95

    var body: some View {
        VStack{
            ScrollView {
                AppImage(
                    urlString: nurse?.image,
                    width: width, contentMode: .fill,
                    backgroundColor: .clear
                )
                nurseInfo
                reviewsSection
            }
    
            requestButton
        }
        .padding(5)
        .appNavigationBar(title: "")
        .sheet(isPresented: $showAllReviews) {
             AllReviewsSheet(reviews: nurse?.reviews ?? [])
//                .background(.appBackground)
         }
    }
}



extension NurseDetailsScreen {
    var nurseInfo: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(nurse?.fullName ?? "unknown_nurse".localized())
                    .font(.title2)
                    .bold()
                Text(nurse?.specialization ?? "general_care".localized())
                    .font(.title3)
                    .foregroundStyle(.appPrimary)
            }
           // Spacer()
            HStack {
                if let rating = nurse?.rating {
                    Text("\(rating)")
                        .font(.title3)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(5)
    }

    var requestButton: some View {
        Button {
            appRouter.pushView(
                RequestScreen(
                    nurse: nurse
                ).environmentObject(vm)
            )
        } label: {
            Text("create_request".localized())
                .font(.title3)
        }
        .buttonStyle(AppButton(kind: .solid, width: 300))
    }
}

extension NurseDetailsScreen {
    var reviewsSection: some View {
      //  let reviews = nurse?.reviews ?? []
        
        guard let reviews = nurse?.reviews, !reviews.isEmpty  else { return EmptyView()}
        
        return Section {
            VStack(spacing: 8) {
                ForEach(reviews.prefix(2), id: \.id) { review in
                    ReviewCellView(review: review)
                    
                    Divider()
                }
                if reviews.count > 2 {
                    Button(action: { showAllReviews = true }) {
                        Text("See More")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        } header: {
            HStack {
                Text("reviews".localized())
                    .font(.title2)
                    .bold()
                Spacer()
            }
        }
    }
}

struct AllReviewsSheet: View {
    var reviews: [Review]

    var body: some View {
        NavigationView {
            List(reviews, id: \.id) { review in
                ReviewCellView(review: review)
            }
            .listStyle(.plain)
            .navigationTitle("All Reviews")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NurseDetailsScreen(nurse: Nurse.mock)
}
