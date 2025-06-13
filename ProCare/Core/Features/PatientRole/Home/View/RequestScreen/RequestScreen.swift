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
    let profile = AppUserDefaults.shared.getCodable(Profile.self, forKey: .profileData)

    var body: some View {
        VStack{
            NurseCell
            addressCell
            totalRequestView
            Spacer()
            ConfirmButton
        }
        .background(.appBackground)
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

                HStack{
                    Text("\(nurse?.rating ?? 0)")
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }

            Spacer()
        }.padding()
    }

    var addressCell: some View{
        VStack(alignment: .leading){
            Text("address".localized())
                .bold()
                .font(.title2)

            Text("\(profile?.governorate ?? "")-\(profile?.city ?? "")-\(profile?.addressNotes ?? "" )")
                .font(.title3)
                .foregroundStyle(.gray)
                .lineLimit(3)
        }
        .alignHorizontally(.leading)
        .padding()
        .backgroundCard(color: .white, cornerRadius: 5, shadowRadius: 0.5, shadowColor: .gray)
        .padding()
    }

    var totalRequestView: some View{
        let totala = (vm.totalPrice + (vm.visitServicePrice ?? 0)).asEGPCurrency()
       return VStack{
            VStack{
                Text("services".localized() + ":")
                    .font(.title2)
                    .bold()
                    .alignHorizontally(.leading)

                ForEach(vm.selectedServices, id: \.id) { result in
                    HStack{
                        Text(result.name ?? "" )
                            .font(.title3)

                        Spacer()

                        Text(result.price?.asEGPCurrency() ?? "")
                           
                           
                    }
                }
                
                HStack{
                    Text("visit_Fee".localized())
                    Spacer()
                    Text(vm.visitServicePrice?.asEGPCurrency() ?? "")
                }
                
            }

            Divider()
                .padding(.horizontal)

            HStack{
                Text("total".localized())
                    .bold()
                    .font(.title2)

                Spacer()

                Text(totala)
                    .bold()
                    .font(.title2)
            }  .foregroundStyle(.appPrimary)
        }
        .padding()
        .backgroundCard(color: .white, cornerRadius: 5, shadowRadius: 0.5, shadowColor: .gray)
        .padding()
    }

    var ConfirmButton: some View {
        let parameters :[String : Any]  = [
           // "nurseId": "24998975-118d-4f79-089a-08dd8377516a"
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
        RequestScreen()
    }
}
