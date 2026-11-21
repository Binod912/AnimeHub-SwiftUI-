import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \AnimeBookmark.createdAt, order: .reverse) private var bookmarks: [AnimeBookmark]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedKind = "watchlist"

    private var filtered: [AnimeBookmark] {
        bookmarks.filter { $0.kind == selectedKind }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Library", selection: $selectedKind) {
                    Text("Watchlist").tag("watchlist")
                    Text("Favorites").tag("favorite")
                }
                .pickerStyle(.segmented)
                .padding()

                if filtered.isEmpty {
                    ContentUnavailableView(
                        selectedKind == "favorite" ? "No favorites yet" : "Your watchlist is empty",
                        systemImage: selectedKind == "favorite" ? "heart" : "bookmark",
                        description: Text("Save anime from its detail page to see it here.")
                    )
                } else {
                    List {
                        ForEach(filtered) { item in
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 8).fill(.secondary.opacity(0.15))
                                }
                                .frame(width: 60, height: 82)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading) {
                                    Text(item.title).font(.headline)
                                    if let score = item.score {
                                        Label(String(format: "%.1f", score), systemImage: "star.fill")
                                            .font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Button(role: .destructive) {
                                    modelContext.delete(item)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Library")
        }
    }
}
