//
//  NuresDetails.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import SwiftUI

struct NurseDetailsScreen: View {
    var servicesIds: [ServiceItem] = []
    var nurse: Nurse?
    @EnvironmentObject var appRouter : AppRouter

    var body: some View {
        VStack {
            AppImage(urlString: nurse?.image)
            nurseInfo
            reviewsSection
            requestButton
        }
        .padding(5)
        .appNavigationBar(title: "")
    }
}

extension NurseDetailsScreen {
    var nurseInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(nurse?.fullName ?? "unknown_nurse".localized())
                    .font(.title2)
                    .bold()
                Text(nurse?.specialization ?? "general_care".localized())
                    .font(.title3)
                    .foregroundStyle(.appPrimary)
            }
            Spacer()
            HStack {
                if let rating = nurse?.rating {
                    Text(rating)
                        .font(.title3)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(5)
    }

    var reviewsSection: some View {
        Section {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { _ in
                        ReviewCellView()
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

    var requestButton: some View {
        Button {
            appRouter.pushView(RequestScreen(nurse: nurse, serviceItems: servicesIds))
        } label: {
            Text("create_request".localized())
                .font(.title3)
        }
        .buttonStyle(AppButton(kind: .solid, width: 300))
    }
}

#Preview {
    NurseDetailsScreen()
}
