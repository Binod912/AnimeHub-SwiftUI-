import SwiftUI
import SwiftData

struct AnimeDetailView: View {
    @Environment(DependencyContainer.self) private var dependencies
    @Environment(\.modelContext) private var modelContext
    @Query private var bookmarks: [AnimeBookmark]
    @State private var detailViewModel: DetailViewModel?

    let anime: Anime

    private var isFavorite: Bool {
        bookmarks.contains { $0.animeID == anime.id && $0.kind == "favorite" }
    }

    private var isWatchlisted: Bool {
        bookmarks.contains { $0.animeID == anime.id && $0.kind == "watchlist" }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                poster
                Text(detailViewModel?.anime?.displayTitle ?? anime.displayTitle)
                    .font(.largeTitle.bold())

                HStack(spacing: 14) {
                    Label(anime.scoreText, systemImage: "star.fill")
                    if let episodes = anime.episodes { Label("\(episodes) eps", systemImage: "tv") }
                    if let year = anime.year { Label(String(year), systemImage: "calendar") }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                HStack {
                    Button {
                        toggle(kind: "favorite", currentlySaved: isFavorite)
                    } label: {
                        Label(isFavorite ? "Favorited" : "Favorite",
                              systemImage: isFavorite ? "heart.fill" : "heart")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)

                    Button {
                        toggle(kind: "watchlist", currentlySaved: isWatchlisted)
                    } label: {
                        Label(isWatchlisted ? "In Watchlist" : "Watchlist",
                              systemImage: isWatchlisted ? "bookmark.fill" : "bookmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                if !anime.genres.isEmpty {
                    Text(anime.genres.joined(separator: " • "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("Synopsis").font(.title2.bold())
                Text(detailViewModel?.anime?.synopsis ?? anime.synopsis ?? "No synopsis available.")
                    .font(.body)
                    .textSelection(.enabled)

                if let status = anime.status {
                    LabeledContent("Status", value: status)
                }
                if let rating = anime.rating {
                    LabeledContent("Rating", value: rating)
                }

                if let trailer = detailViewModel?.anime?.trailerURL ?? anime.trailerURL {
                    Link(destination: trailer) {
                        Label("Watch trailer", systemImage: "play.rectangle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if detailViewModel == nil {
                detailViewModel = DetailViewModel(animeID: anime.id, repository: dependencies.repository)
            }
            await detailViewModel?.load()
        }
    }

    private var poster: some View {
        AsyncImage(url: detailViewModel?.anime?.imageURL ?? anime.imageURL) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            RoundedRectangle(cornerRadius: 14).fill(.secondary.opacity(0.15))
                .overlay(ProgressView())
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func toggle(kind: String, currentlySaved: Bool) {
        if currentlySaved {
            let matches = bookmarks.filter { $0.animeID == anime.id && $0.kind == kind }
            matches.forEach { modelContext.delete($0) }
        } else {
            modelContext.insert(AnimeBookmark(anime: detailViewModel?.anime ?? anime, kind: kind))
        }
    }
}
