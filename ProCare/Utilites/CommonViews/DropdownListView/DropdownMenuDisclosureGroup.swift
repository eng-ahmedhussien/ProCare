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
    var placeholder: String = "select"
    var options: [T]
    
    private var selectedName: String {
        options.first(where: { $0.id == selectedId })?.name ?? placeholder
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
                            .background(
                                option.id == selectedId ?
                                Color.appPrimary : Color.clear
                            )
                    }
                }
            }
        }
        .padding()
        .backgroundCard(cornerRadius: 30, shadowRadius: 1)
      //  .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray))
        .padding(.horizontal)
        .tint(.black)
    }
}

struct MockDropdownOption: DropdownOption, Hashable {
    let id: Int
    let name: String
}

struct DropdownListView_Previews: PreviewProvider {
    @State static var selectedId: Int? = nil
    static let options = [
        MockDropdownOption(id: 1, name: "Option 1"),
        MockDropdownOption(id: 2, name: "Option 2"),
        MockDropdownOption(id: 3, name: "Option 3")
    ]
    
    static var previews: some View {
        
        DropdownListView<MockDropdownOption>(selectedId: $selectedId, options: options)
    }
}
