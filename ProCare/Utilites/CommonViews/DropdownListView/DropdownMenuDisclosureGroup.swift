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
    var placeholder: String = "select".localized()
    var options: [T]
    var maxHeight: CGFloat = 200 // Maximum height for the dropdown content
    
    private var selectedName: String {
        options.first(where: { $0.id == selectedId })?.name ?? placeholder
    }
    
    var body: some View {
        DisclosureGroup(selectedName, isExpanded: $isExpanded) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
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
                                .foregroundStyle(.appSecode)
                                .padding(.horizontal, 16)
                                .background(
                                    option.id == selectedId ?
                                        .service : Color.clear
                                )
                                .cornerRadius(30)
                        }
                    }
                }
            }
            .frame(maxHeight: maxHeight)
        }
        .padding()
        .backgroundCard(
            cornerRadius: 30,
            shadowRadius: 1.5,
            shadowColor: .appSecode,
            shadowY: 0.5
        )
        .padding(.horizontal)
        .tint(.black)
    }
}

struct MockDropdownOption: DropdownOption, Hashable {
    let id: Int
    let name: String
}

struct DropdownListView_Previews: PreviewProvider {
    @State static var selectedId: Int? = 1
    static let options = [
        MockDropdownOption(id: 1, name: "Option 1"),
        MockDropdownOption(id: 2, name: "Option 2"),
        MockDropdownOption(id: 3, name: "Option 3"),
        MockDropdownOption(id: 4, name: "Option 4"),
        MockDropdownOption(id: 5, name: "Option 5"),
        MockDropdownOption(id: 6, name: "Option 6"),
        MockDropdownOption(id: 7, name: "Option 7"),
        MockDropdownOption(id: 8, name: "Option 8"),
        MockDropdownOption(id: 9, name: "Option 9"),
        MockDropdownOption(id: 10, name: "Option 10"),
        MockDropdownOption(id: 11, name: "Option 11"),
        MockDropdownOption(id: 12, name: "Option 12")
    ]
    
    static var previews: some View {
        DropdownListView<MockDropdownOption>(selectedId: $selectedId, options: options)
    }
}
