    //
    //  NurseCellView.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 24/04/2025.
    //

    import SwiftUI

    struct NurseCellView: View {
        var nurse: Nurse
        let distance: Double? // in meters

        var body: some View {
            HStack(alignment: .center, spacing: 16) {
                AsyncImage(url: URL(string: nurse.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .foregroundColor(.gray.opacity(0.4))
                }
                .accessibilityLabel(Text(nurse.fullName ?? "Nurse"))

                VStack(alignment: .leading, spacing: 4) {
                    Text(nurse.fullName ?? "no_title".localized())
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.appSecode)
                        .accessibilityLabel(Text("Name: \(nurse.fullName ?? "Unknown")"))

                    Text(nurse.specialization ?? "no_description".localized())
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .accessibilityLabel(Text("Specialization: \(nurse.specialization ?? "Unknown")"))

                    if let distance = distance {
                        Text(String(format: NSLocalizedString("km_away", comment: ""), distance / 1000))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .accessibilityLabel(Text("\(distance / 1000, specifier: "%.1f") kilometers away"))
                    }
                }

                Spacer()

                Label(String(format: "%.1f", nurse.rating ?? 0), systemImage: (nurse.rating ?? 0).starRateIcon)
                        .labelStyle(.titleAndIcon)
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                        .accessibilityLabel(Text("Rating"))
            }
            .padding()
            .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
            .padding(.horizontal)
            .padding(.vertical,8)
            .opacity(nurse.isBusy ?? false ? 0.5 : 1)
        }
    }



#Preview {
        VStack{
            NurseCellView(nurse: Nurse.mock, distance: 100)
            NurseCellView(nurse: Nurse.mock, distance: 100)
            NurseCellView(nurse: Nurse.mock, distance: 100)
        }
    }


