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
                ForEach(options, id: \.id) { option in
                    Button(action: {
                        withAnimation {
                            selectedId = option.id
                            isExpanded = false
                        }
                    }) {
                        Text(option.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .foregroundStyle(.black)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        .padding(.horizontal)
        .tint(.black)
    }
}

//struct DropdownListView_Previews: PreviewProvider {
//    struct PreviewWrapper: View {
//        @State private var selectedCityId: Int = nil
//
//        let sampleCities: [City] = [
//            City(id: 1, nameAr: "القاهرة", nameEn: "Cairo", governorateId: 1, governorate: "Cairo Governorate"),
//            City(id: 2, nameAr: "الإسكندرية", nameEn: "Alexandria", governorateId: 2, governorate: "Alexandria Governorate"),
//            City(id: 3, nameAr: "الجيزة", nameEn: "Giza", governorateId: 3, governorate: "Giza Governorate")
//        ]
//
//        var body: some View {
//            VStack {
//                DropdownListView(selectedId: $selectedCityId, options: sampleCities)
//
//                if let selectedId = selectedCityId,
//                   let selectedCity = sampleCities.first(where: { $0.id == selectedId }) {
//                    Text("Selected: \(selectedCity.name)")
//                        .padding()
//                } else {
//                    Text("No city selected")
//                        .padding()
//                }
//            }
//            .padding()
//        }
//    }
//
//    static var previews: some View {
//        PreviewWrapper()
//    }
//}
//
