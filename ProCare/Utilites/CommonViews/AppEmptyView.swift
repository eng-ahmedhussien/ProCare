//
//  EmptyRequestsView.swift
//  ProCare
//
//  Created by ahmed hussien on 23/05/2025.
//


import SwiftUI

struct AppEmptyView: View {
    var title: String = "No Requests"
    var message: String = "You don’t have any requests at the moment."
    var imageName: String = "tray" // system icon

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.gray)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
