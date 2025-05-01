//
//  FontsView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//

import SwiftUI

struct FontsView: View {
    var body: some View {
        VStack(spacing: 20){
            Text("Hello, World largeTitle")
                .font(.largeTitle)
            Text("Hello, World title")
                .font(.title)
            Text("Hello, World title2")
                .font(.title2)
            Text("Hello, World title3")
                .font(.title3)
            Text("Hello, World headline")
                .font(.headline)
            Text("Hello, World subheadline")
                .font(.subheadline)
            Text("Hello, World callout")
                .font(.callout)
            Text("Hello, World caption")
                .font(.caption)
            Text("Hello, World caption2")
                .font(.caption2)
            Text("Hello, World footnote")
                .font(.footnote)
  
        }
    }
}

#Preview {
    FontsView()
}
