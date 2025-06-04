struct CategoryCard: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 8) {
                AppImage(
                    urlString: category.imageUrl ?? "",
                    width: 50,
                    height: 50
                 
                )
                .foregroundStyle(.appPrimary)
                
                Text(category.name ?? "Unknown Category")
                    .font(.headline)
                    .foregroundStyle(.appPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.service)
                    .shadow(radius: 2)
            )
        }
        .buttonStyle(.plain)
    }
}