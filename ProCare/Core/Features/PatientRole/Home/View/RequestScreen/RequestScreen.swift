//
//  RequestScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import SwiftUI

struct RequestScreen: View {
    @EnvironmentObject var vm: HomeVM
    @EnvironmentObject var appRouter: AppRouter

    var nurse: Nurse?
    var profile =  KeychainHelper.shared.getData(Profile.self, forKey: .profileData)

    var body: some View {
        VStack{
            NurseCell
            addressCell
            totalRequestView
            Spacer()
            ConfirmButton
        }
        .appNavigationBar(title: "review_request".localized())
    }
}

extension RequestScreen{
    var NurseCell: some View{
        HStack(alignment: .center){
            AsyncImage(url: URL(string: nurse?.image ?? "https://picsum.photos/200/300.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white.opacity(0.6))
            }

            VStack(alignment: .leading){
                Text(nurse?.fullName ?? "no_title".localized())
                    .font(.headline)
                    .bold()

                Text(nurse?.specialization ?? "no_description".localized())
                    .font(.subheadline)
                    .bold()

                Label(
                    String(format: "%.1f", nurse?.rating ?? 0),
                    systemImage: (nurse?.rating ?? 0).starRateIcon
                )
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(.yellow)
                    .font(.subheadline)
                    .accessibilityLabel(Text("Rating"))
            }

            Spacer()
        }.padding()
    }

    var addressCell: some View{
        VStack(alignment: .leading){
            Text("address".localized())
                .font(.headline)
                .foregroundStyle(.appSecode)

                // Location details with improved hierarchy
                VStack(alignment: .leading, spacing: 4) {
                    if let governorate = profile?.governorate,
                       let city = profile?.city,
                       !governorate.isEmpty || !city.isEmpty {
                        Text("\(governorate)\(governorate.isEmpty ? "" : " - ")\(city)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Address notes with better conditional rendering
                    if let addressNotes = profile?.addressNotes, !addressNotes.isEmpty {
                        Text(addressNotes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            
                // Current location with proper spacing
                if !LocationManager.shared.address.isEmpty {
                    VStack{
                        Text("current_location")
                            .font(.headline)
                            .foregroundStyle(.appSecode)
                        
                        Text(LocationManager.shared.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
        }
        .alignHorizontally(.leading)
        .padding()
        .backgroundCard(color: .white, cornerRadius: 5, shadowRadius: 0.5, shadowColor: .gray)
        .padding()
    }
    
    var totalRequestView: some View {
        let total = (vm.totalPrice + (vm.visitServicePrice ?? 0)).asEGPCurrency()
        
        return VStack(alignment: .leading, spacing: 16) {
            // Service List Section
            VStack(alignment: .leading, spacing: 8) {
                Text("services".localized() + ":")
                    .font(.headline) // Strong section header
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isHeader)

                ForEach(vm.selectedServices, id: \.id) { result in
                    HStack {
                        Text(result.name ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(result.price?.asEGPCurrency() ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                HStack {
                    Text("visit_Fee".localized())
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(vm.visitServicePrice?.asEGPCurrency() ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Divider().padding(.vertical, 4)

            // Total Row
            HStack {
                Text("total".localized())
                    .font(.title2)
                    .fontWeight(.semibold) // Use weight here instead of .bold()
                Spacer()
                Text(total)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.appPrimary) // Use your app's primary/accent color
        }
        .padding()
        .backgroundCard(color: .white, cornerRadius: 5, shadowRadius: 0.5, shadowColor: .gray)
        .padding()
    }


    var ConfirmButton: some View {
        let parameters :[String : Any]  = [
            "nurseId": nurse?.id ?? "",
            "patientId": profile?.id ?? 0,
            "addressId": profile?.addressId ?? 0,
            "latitude": profile?.latitude ?? "",
            "longitude": profile?.longitude ?? "",
            "serviceIds": vm.selectedServices.map { $0.id }
        ]
        return  Button {
            Task{
                await vm.submitRequest(Parameters: parameters){
                    appRouter.popToRoot()
                }
            }
        } label: {
            Text("confirm".localized())
                .font(.title3)
        }
        .buttonStyle(AppButton(kind: .solid,width: 300 ))
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack{
        RequestScreen(profile: Profile.mock).environmentObject(HomeVM())
    }
}
