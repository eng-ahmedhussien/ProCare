import SwiftUI
import MapKit

struct PharmacyCardView: View {
    let pharmacy: PharmacyItem
    let onCallTap: (PharmacyItem) -> Void
    let onMapTap: (Double, Double, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name
            Text(pharmacy.name ?? "")
                .font(.system(.headline, design: .default))
                .foregroundColor(.primary)
            
            // Location details
            VStack(alignment: .leading, spacing: 2) {
                Text("\(pharmacy.cityName ?? "")\("location_separator".localized())\(pharmacy.governorateName ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Line number and buttons
            HStack {
                if let lineNumber = pharmacy.lineNumber {
                    Text("\("line".localized()): \(lineNumber)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 10) {
                    Button(action: {
                        onCallTap(pharmacy)
                    }) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    Button(action: {
                        onMapTap(pharmacy.latitude ?? 0, pharmacy.longitude ?? 0, pharmacy.name ?? "")
                    }) {
                        Image(systemName: "map.fill")
                            .foregroundColor(.green)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.black).opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
} 


#Preview {
    PharmacyCardView(pharmacy: PharmacyItem.mock, onCallTap: {_ in}, onMapTap: {_,_,_ in })
}
