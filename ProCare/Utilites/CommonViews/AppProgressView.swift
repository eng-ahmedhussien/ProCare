//
//  AppProgressView.swift
//  ProCare
//
//  Created by ahmed hussien on 29/06/2025.
//

import SwiftUI

struct AppProgressView: View {
    var body: some View {
        ProgressView()
            .appProgressStyle(color: .appPrimary)
            .padding()
    }
}

#Preview {
    AppProgressView()
}
