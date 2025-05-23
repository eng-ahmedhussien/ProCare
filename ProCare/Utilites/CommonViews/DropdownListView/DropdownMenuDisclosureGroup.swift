//
//  DropdownMenuDisclosureGroup.swift
//  ProCare
//
//  Created by ahmed hussien on 05/05/2025.
//

import SwiftUI

struct DropdownListView<T: DropdownOption>: View {
    @State private var isExpanded: Bool = false
    @Binding var selectedId: Int?
    var options: [T]
    
    private var selectedName: String {
        options.first(where: { $0.id == selectedId })?.name ?? "Select an option"
    }

    var body: some View {
        DisclosureGroup(selectedName, isExpanded: $isExpanded) {
            VStack(alignment: .leading) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        if selectedId != option.id {
                            withAnimation {
                                selectedId = option.id
                            }
                        }
                        isExpanded = false
                    }) {
                        Text(option.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                option.id == selectedId ?
                                Color.gray : Color.clear
                            )
                            .cornerRadius(6)
                    }
                    //.buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 4)
        }
        .foregroundStyle(.black)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        .padding(.horizontal)
        .tint(.black)
    }
}
